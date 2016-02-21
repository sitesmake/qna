require_relative '../acceptance_helper'

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
    fill_in 'Answer', with: 'answer text'
  end

  scenario 'User adds file when asks question', js: true do
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Post answer'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds multiple files when asks question', js: true do
    click_on 'add file'

    page.all("input[type='file']")[0].set "#{Rails.root}/spec/spec_helper.rb"
    page.all("input[type='file']")[1].set "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Post answer'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

end
