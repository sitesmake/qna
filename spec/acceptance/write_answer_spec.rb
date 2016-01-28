require 'rails_helper'

feature 'User can write answer to question', %q{
  In order to answer question
  As an user
  I want to create answer
} do

  scenario 'User create answer' do
    user = create(:user)
    question = create(:question)

    sign_in(user)

    visit question_path(question)
    click_on 'Answer this question'

    expect(page).to have_current_path(new_question_answer_path(question))
    fill_in 'answer_body', with: 'My answer.'
    click_on 'Post answer'

    expect(page).to have_current_path(question_path(question))
    expect(page).to have_content 'Your Answer was successfully created'
    expect(page).to have_content 'My answer.'

  end
end
