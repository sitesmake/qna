class Search < ActiveInteraction::Base
  string :query
  string :search_in, default: 'Everywhere'

  validates :query, presence: true

  SEARCH_OPTIONS = %w(Questions Answers Comments Users)

  def execute
    escaped_query = Riddle::Query.escape(query)

    if SEARCH_OPTIONS.include? search_in
      search_in.singularize.constantize.search(escaped_query)
    else
      ThinkingSphinx.search escaped_query
    end
  end
end
