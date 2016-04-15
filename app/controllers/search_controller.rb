class SearchController < ApplicationController
  authorize_resource

  def search
    search = Search.run({ query: params[:query], search_in: params[:search_in] })
    @results = search.result || []

    respond_with @results
  end
end
