require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

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

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in "Answer", with: 'edited answer'
        save_and_open_page
        click_on 'Save'
      end


      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
    end

    scenario 'try to edit other user question'
  end



end
