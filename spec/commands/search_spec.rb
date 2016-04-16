require 'rails_helper'

RSpec.describe Search do
  it "does not start searching with blank query" do
    expect(ThinkingSphinx).to_not receive(:search)
    Search.run({})
  end

  it "search everywhere without options" do
    expect(ThinkingSphinx).to receive(:search).with("not_blank_line")
    Search.run({query: "not_blank_line"})
  end

  Search::SEARCH_OPTIONS.each do |option|
    it "search in #{option} category" do
      expect(option.singularize.constantize).to receive(:search).with("not_blank_line")
      Search.run({query: "not_blank_line", search_in: option})
    end
  end

  it "falls back to search everywhere with wrong search_in options" do
    expect(ThinkingSphinx).to receive(:search).with("not_blank_line")
    Search.run({query: "not_blank_line", search_in: "Incorrect"})
  end
end
