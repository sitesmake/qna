require 'rails_helper'

feature 'Guest can view questions', %q{
  In order to select question
  As an guest
  I want to view list of questions
} do

  scenario 'Guest views the questions' do
    questions = create_list(:question, 3)

    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
