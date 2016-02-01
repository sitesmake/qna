require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to make registered-user actions
  As an guest
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered guest try to sign in' do
    visit root_path
    expect(page).to have_link 'Sign in'

    sign_in(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered guest try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'no-reg@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password'
  end

end
