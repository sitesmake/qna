require 'rails_helper'

feature 'User can view questions', %q{
  In order to select question
  As an user
  I want to view list of questions
} do

  scenario 'User views the questions' do

    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'text of the question'
    click_on 'Ask question'

    expect(page).to have_content 'Your Question was successfully created'
  end
end
