module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider' => 'facebook',
      'uid' => '111555',
      'info' => {
        'email' => 'mark@facebook.com',
        'image' => 'mark_thumb_url'
      },
      'token' => 'mock_token'
    })

    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      'provider' => 'vkontakte',
      'uid' => '111777',
      'token' => 'mock_token'
    })
  end
end
