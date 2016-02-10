require_relative 'acceptance_helper'

feature 'Best answer', %q{
  In order to select best answer
  As author of question
  I'd like to be able to set best answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, user: user, question: question) }
  given!(:answer2) { create(:answer, user: user, question: question) }

  before do
    question.best_answer_id = answer1.id
    question.save!
  end

  scenario 'Unauthenticated user can not select best answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Set as best answer'
  end

  describe 'Authenticated user' do
    scenario 'Not-author of question can not select best answer', js: true do
      other_user = create(:user)
      sign_in other_user
      visit question_path(question)
      expect(page).to_not have_link 'Set as best answer'
    end

    scenario 'Author of question can select best answer', js: true do
      sign_in user
      visit question_path(question)


      within ".answer-#{answer1.id}" do
        expect(page).to_not have_link 'Set as best answer'
      end
      within ".answer-#{answer2.id}" do
        expect(page).to have_link 'Set as best answer'
      end

      click_on 'Set as best answer'

      within ".answer-#{answer1.id}" do
        expect(page).to have_link 'Set as best answer'
      end
      within ".answer-#{answer2.id}" do
        expect(page).to_not have_link 'Set as best answer'
      end

    end
  end
end
