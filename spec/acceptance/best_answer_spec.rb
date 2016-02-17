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
  given!(:answer3) { create(:answer, user: user, question: question) }

  before do
    answer1.make_best
  end

  scenario 'Guest user can not select best answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Set as best answer'
  end

  scenario 'Not-author of question can not select best answer', js: true do
    other_user = create(:user)
    sign_in other_user
    visit question_path(question)
    expect(page).to_not have_link 'Set as best answer'
  end

  describe 'Author of question' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'view select best answer links, except current', js: true do
      expect(page.find(:xpath, '(//div[@class="answers"]/div)[1]')).to have_content answer1.body

      within ".answer-#{answer1.id}" do
        expect(page).to_not have_link 'Set as best answer'
      end
      within ".answer-#{answer2.id}" do
        expect(page).to have_link 'Set as best answer'
      end
      within ".answer-#{answer3.id}" do
        expect(page).to have_link 'Set as best answer'
      end
    end

    scenario 'can change best answer', js: true do
      within ".answer-#{answer2.id}" do
        click_on "Set as best answer"
      end

      expect(page.find(:xpath, '(//div[@class="answers"]/div)[1]')).to have_content answer2.body
    end
  end
end
