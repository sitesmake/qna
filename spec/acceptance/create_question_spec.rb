require 'rails_helper'

feature 'User can create question', %q{
  In order to ask question
  As an user
  I want to create question
} do

  scenario 'User create the question' do
    user = create(:user)

    sign_in(user)

    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'text of the question'
    click_on 'Ask question'

    expect(page).to have_content 'Your Question was successfully created'
  end

  scenario 'User can not create the question with blank title or body' do
    user = create(:user)

    sign_in(user)

    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: 'text of the question'
    click_on 'Ask question'
    expect(page).not_to have_content 'Your Question was successfully created'
    expect(page).to have_content "Title can't be blank"

    click_on 'Ask question'
    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: ''
    click_on 'Ask question'
    expect(page).not_to have_content 'Your Question was successfully created'
    expect(page).to have_content "Body can't be blank"
  end


  scenario 'Guest can not create the question' do
    visit questions_path

    click_on 'Ask question'

    expect(page).not_to have_link('Ask question')
    expect(page).to have_content('You need to sign in or sign up before continuing')

  end
end
