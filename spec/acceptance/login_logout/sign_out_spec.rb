require 'rails_helper'

feature 'User sign out', %q{
  In order to sign out
  As an user
  I want to be able to sign out
} do

  scenario 'Logged user sign out' do
    User.create!(email: 'user@test.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path

    expect(page).to have_link('Sign out')
    click_on 'Sign out'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully'
  end

  scenario 'Non-logged user do not view sign out button' do
    visit root_path
    expect(page).not_to have_link('Sign out')
  end

end
