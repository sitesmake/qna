require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Guest can search', %q{
  In order to search
  As an guest
  I want to be able search with sphinx
} do

  given!(:for_search_title_question) { create :question, title: 'for search title question'}
  given!(:for_search_body_question) { create :question, body: 'for search body question'}
  given!(:for_search_answer) { create :answer, body: 'for search answer' }
  given!(:for_search_comment) { create :comment, body: 'for search comment' }
  given!(:for_search_user) { create :user, email: 'search@mail.ru' }
  given!(:not_for_search) { create :question, title: 'hidden title', body: 'hidden body'}

  before do
    index
    visit root_path
  end

  scenario 'Search everywhere', sphinx: true do
    fill_in 'query', with: 'search'
    click_on 'Search'

    within '#search_results' do
      expect(page).to_not have_content "hidden"
      expect(page).to have_selector('h3', count: 5)
    end
  end

  scenario 'Search in questions', sphinx: true do
    fill_in 'query', with: 'for search'
    select 'Questions', from: 'search_in'
    click_on 'Search'

    within '#search_results' do
      expect(page).to have_content "for search title question"
      expect(page).to have_selector('h3', count: 2)
    end
  end

  scenario 'Search in answers', sphinx: true do
    fill_in 'query', with: 'for search'
    select 'Answers', from: 'search_in'
    click_on 'Search'

    within '#search_results' do
      expect(page).to have_content "for search answer"
      expect(page).to have_selector('h3', count: 1)
    end
  end

  scenario 'Search in comments', sphinx: true do
    fill_in 'query', with: 'for search'
    select 'Comments', from: 'search_in'
    click_on 'Search'

    within '#search_results' do
      expect(page).to have_content "for search comment"
      expect(page).to have_selector('h3', count: 1)
    end
  end

  scenario 'Search in users', sphinx: true do
    fill_in 'query', with: 'search'
    select 'Users', from: 'search_in'
    click_on 'Search'

    within '#search_results' do
      expect(page).to have_content "search@mail.ru"
      expect(page).to have_selector('h3', count: 1)
    end
  end

end
