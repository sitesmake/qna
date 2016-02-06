require_relative 'acceptance_helper'

feature 'User answer', %q{
  In order to write answer
  As an authenticated user
  I want to be able to create answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Answer', with: 'Use Rails!'
    click_on 'Post answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Use Rails!'
    end
  end
end
