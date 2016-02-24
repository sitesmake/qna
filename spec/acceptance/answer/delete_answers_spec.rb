require_relative '../acceptance_helper'

feature 'User delete answer', %q{
  In order to delete answer
  As an authenticated user
  I want to be able to delete answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes question', js: true do
  	sign_in user

    visit question_path(question)

    click_on '(delete)'

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'Other user do not see delete question link' do
    other_user = create(:user)
    sign_in other_user

	  visit question_path(question)

	  expect(current_path).to_not have_link '(delete)'
  end

  scenario 'Guest do not see delete question link' do
	  visit question_path(question)

	  expect(current_path).to_not have_link '(delete)'
  end

end
