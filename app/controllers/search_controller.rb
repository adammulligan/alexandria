class SearchController < ApplicationController
  def index
    return unless @query = params[:q]

    pagination_opts = {page: params[:page], per_page: 50}
    @books = Search.search(@query).paginate(pagination_opts)
  end
end
