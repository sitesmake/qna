require_relative '../acceptance_helper'

feature 'Removes files from answer', %q{
  In order to remove attached file
  As an answer's author
  I'd like to be able destroy uploaded files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer)}

  describe 'Author' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'removes file from answer', js: true do
      expect(page).to have_link attachment.file.identifier
      click_on "(remove this file)"
      expect(page).to_not have_link attachment.file.identifier
    end
  end

  scenario 'Other user do not see remove attachment link' do
    other_user = create(:user)
    sign_in other_user
    visit question_path(question)
    expect(page).to_not have_link '(remove this file)'
  end

  scenario 'Unauthenticated user do not see remove attachment link' do
    visit question_path(question)
    expect(page).to_not have_link '(remove this file)'
  end

end
