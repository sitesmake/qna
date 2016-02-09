require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'edit his answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in "Answer", with: 'edited answer'
        click_button 'Save'
      end

      expect(page).to_not have_button 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
    end

    scenario 'try to edit other user answer', js: true do
      other_user = create(:user)
      answer.user = other_user
      answer.save!

      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end



end
