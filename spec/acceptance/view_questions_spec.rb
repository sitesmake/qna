require 'rails_helper'

feature 'Guest can view questions', %q{
  In order to select question
  As an guest
  I want to view list of questions
} do

  scenario 'Guest views the questions' do
    question1 = create(:question, title: 'Question 1')
    question2 = create(:question, title: 'Question 2')

    visit questions_path

    expect(page).to have_content 'Question 1'
    expect(page).to have_content 'Question 2'
  end
end
