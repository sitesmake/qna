class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :user_find_and_sign_in

  def facebook
  end

  def vkontakte
  end

  private

  def user_find_and_sign_in
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: request.env['omniauth.auth']['provider']) if is_navigational_format?
    end
  end
end

