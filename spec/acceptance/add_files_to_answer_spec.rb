require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User adds file when asks question' do
    fill_in 'Answer', with: 'answer text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post answer'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

end
