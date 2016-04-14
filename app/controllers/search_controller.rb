class SearchController < ApplicationController
	authorize_resource

	def search
		search = Search.run(params[:query])
		@results = search.result || []

		respond_with @results
	end
end