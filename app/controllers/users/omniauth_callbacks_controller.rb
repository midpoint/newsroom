class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    raise request.env["omniauth.auth"].inspect
  end

  def failure
    redirect_to root_path
  end
end
