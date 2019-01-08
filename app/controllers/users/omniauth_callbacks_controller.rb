# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!

  def github
    user = find_user!(request.env["omniauth.auth"])

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
    else
      session["devise.github_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def find_user!(auth)
    User.where(github_id: auth.uid).first_or_create do |user|
      user.username = auth.info&.nickname
      user.email = auth.info&.email
      user.github_token = auth.credentials&.token
    end
  end
end
