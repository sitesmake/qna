require 'rails_helper'

feature 'User can create question', %q{
  In order to ask question
  As an user
  I want to create question
} do

  scenario 'User create the question' do

    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'text of the question'
    click_on 'Ask question'

    expect(page).to have_content 'Your Question was successfully created'
  end
end
