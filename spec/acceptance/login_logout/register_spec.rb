require 'rails_helper'

feature 'User registration', %q{
  In order to be able to register
  As an guest
  I want to be able to register
} do

  scenario 'Guest can register' do
    visit root_path
    expect(page).to have_link('Register')

    click_link('Register')
    expect(current_path).to eq new_user_registration_path

    fill_in 'Email', with: 'test-new@mail.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content("Welcome! You have signed up successfully.")
    expect(page).to have_link("Sign out")
  end

end
