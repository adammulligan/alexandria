class BooksController < ApplicationController
  def index
    pagination_opts = {page: params[:page], per_page: 50}
    @books = Book.all.paginate(pagination_opts)
  end
end
