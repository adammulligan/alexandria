class CreateSearchView < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        # create an aggregate to return the first element in a set
        execute <<-SQL
          CREATE OR REPLACE FUNCTION public.first_agg ( anyelement, anyelement )
          RETURNS anyelement LANGUAGE sql IMMUTABLE STRICT AS $$
            SELECT $1;
          $$;

          CREATE AGGREGATE public.first (
            sfunc    = public.first_agg,
            basetype = anyelement,
            stype    = anyelement
          );
        SQL

        execute <<-SQL
          DROP MATERIALIZED VIEW IF EXISTS tsvector_search_documents;
          CREATE MATERIALIZED VIEW tsvector_search_documents AS
            SELECT bk.id,
              setweight(to_tsvector('english'::regconfig, coalesce (public.first(bk.name), '')), 'A') ||
              setweight(to_tsvector('english'::regconfig, coalesce (public.first(bk.filename), '')), 'B') ||
              setweight(to_tsvector('english'::regconfig, coalesce (string_agg(c.name, ' '), '')), 'C') ||
              setweight(to_tsvector('english'::regconfig, coalesce (string_agg(a.name, ' '), '')), 'D')
            AS document
            FROM books bk

            LEFT JOIN books_categories bc ON bc.book_id = bk.id
            LEFT JOIN categories c ON bc.category_id = bc.id
            LEFT JOIN authors_books ab ON ab.book_id = bk.id
            LEFT JOIN authors a ON ab.author_id = ab.id

            GROUP BY bk.id;
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP MATERIALIZED VIEW tsvector_search_documents;
        SQL
      end
    end

    add_index :tsvector_search_documents, :document, using: :gin
  end
end
