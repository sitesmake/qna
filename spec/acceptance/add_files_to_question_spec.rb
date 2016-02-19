require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in 'Title', with: 'Title of question'
    fill_in 'Body', with: 'Body of question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ask question'

    expect(page).to have_content 'spec_helper.rb'
  end

end
