require 'rails_helper'

feature 'User sign in through oauth', %q{
  In order to be able to log in through social networks
  As an guest
  I want to be able to sign in
} do

  before do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
  end

  OmniAuth.config.test_mode = true

  scenario 'With email user try to sign in' do
    visit root_path
    click_link 'Sign in'

    mock_auth_hash

    click_link 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from facebook account'
    expect(current_path).to eq root_path
  end

  scenario 'With no-email user try to sign in' do
    visit root_path
    click_link 'Sign in'

    mock_auth_hash

    click_link 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from vkontakte account'
    expect(current_path).to eq root_path
  end

end
