class TagsearchesController < ApplicationController
  def search
    @model = Book
    @word = params[:tag]
    @books = Book.where("tag LIKE?", "%#{@word}%")
    render "tag_searches/tag_search"
  end
end
