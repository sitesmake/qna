require 'rails_helper'

feature 'User can write answer to question', %q{
  In order to answer question
  As an user
  I want to create answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User create answer' do
    sign_in(user)

    visit question_path(question)

    fill_in 'answer_body', with: 'My answer.'
    click_on 'Post answer'

    expect(page).to have_current_path(question_path(question))
    expect(page).to have_content 'Your Answer was successfully created'
    expect(page).to have_content 'My answer.'

  end

  scenario 'User can not create answer with blank field' do
    sign_in(user)

    visit question_path(question)

    fill_in 'answer_body', with: ''
    click_on 'Post answer'

    expect(page).not_to have_content 'Your Answer was successfully created'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Guest can not create answer' do
    visit question_path(question)

    expect(page).not_to have_link('Post answer')
  end
end
