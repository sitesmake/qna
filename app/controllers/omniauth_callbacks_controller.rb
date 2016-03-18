class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    render json: request.env['omniauth.auth']
  end
end

