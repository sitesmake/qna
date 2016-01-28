require 'rails_helper'

feature 'Guest can view questions and answers', %q{
  In order to view question and answers
  As an guest
  I want to view question and list of answers to this question
} do

  scenario 'Guest view the question and answers to that question' do
    question = create(:question)
    answer1 = create(:answer, body: 'answer 1', question: question)
    answer2 = create(:answer, body: 'answer 2')
    answer3 = create(:answer, body: 'answer 3', question: question)

    visit question_path(question)

    expect(page).to have_content 'answer 1'
    expect(page).not_to have_content 'answer 2'
    expect(page).to have_content 'answer 3'
  end
end
