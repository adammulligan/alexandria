class Search
  def self.search search_term
    search_instance = self.new search_term
    search_instance.search
  end

  def initialize search_term
    @query = search_term
  end

  def search
    Book.joins(join_query).order('rank DESC')
  end

  private

  def join_query
    """
      INNER JOIN (
        #{search_query}
      ) AS search_results
      ON search_results.id = books.id
    """.squish
  end

  def search_query
    dirty_query = """
      SELECT id, ts_rank(document, query) AS rank
      FROM tsvector_search_documents, to_tsquery(?) query
      WHERE document @@ query
    """.squish

    ActiveRecord::Base.send(:sanitize_sql_array, [
      dirty_query, search_term
    ])
  end

  def search_term
    lexemes = @query.split(' ')
    lexemes = lexemes.map{|lexeme| "#{lexeme}:*"}
    lexemes.join(' & ')
  end
end
