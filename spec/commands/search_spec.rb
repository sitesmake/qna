require 'rails_helper'

RSpec.describe Search do
  it "includes scopes list" do
    expect(Search::SEARCH_OPTIONS).to eq %w(Questions Answers Comments Users)
  end

  it "does not start searching with blank query" do
    expect(ThinkingSphinx).to_not receive(:search)
    Search.run({})
  end

  it "search everywhere without options" do
    expect(ThinkingSphinx).to receive(:search)
    Search.run({query: "not_blank_line"})
  end

  Search::SEARCH_OPTIONS.each do |option|
    it "search in #{option} category" do
      expect(option.singularize.constantize).to receive(:search)
      Search.run({query: "not_blank_line", search_in: option})
    end
  end
end
