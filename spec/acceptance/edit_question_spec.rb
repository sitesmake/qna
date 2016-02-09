require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link '(edit)'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      expect(page).to have_link '(edit)'
    end

    scenario 'edit his question', js: true do
      click_on '(edit)'

      fill_in "question_title", with: 'edited title'
      fill_in "question_body", with: 'edited body'
      click_button 'Save'

      expect(page).to_not have_button 'Save'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
    end

    scenario 'try to edit other user question', js: true do
      other_user = create(:user)
      question.user = other_user
      question.save!

      visit question_path(question)

      expect(page).to_not have_link '(edit)'
    end
  end
end
