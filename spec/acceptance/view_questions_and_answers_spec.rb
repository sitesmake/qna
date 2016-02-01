require 'rails_helper'

feature 'Guest can view questions and answers', %q{
  In order to view question and answers
  As an guest
  I want to view question and list of answers to this question
} do

  scenario 'Guest view the question and answers to that question' do
    question = create(:question)
    valid_answers = create_list(:answer, 3, question: question)
    invalid_answers = create_list(:answer, 2)

    visit question_path(question)

    valid_answers.each do |answer|
      expect(page).to have_content answer.body
    end

    invalid_answers.each do |answer|
      expect(page).not_to have_content answer.body
    end
  end
end
