# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!
  before_action :authorize_access!

  def github
    user = find_user!

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
    else
      session["devise.github_data"] = auth_hash
      redirect_to root_path
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def auth_hash
    @auth_hash ||= request.env['omniauth.auth']
  end

  def auth_token
    @auth_token ||= auth_hash.credentials&.token
  end

  def client
    @client ||= Octokit::Client.new(access_token: auth_token)
  end

  def find_user!
    User.where(github_id: auth_hash.uid).first_or_create do |user|
      user.username = auth_hash.info&.nickname
      user.email = auth_hash.info&.email
      user.github_token = auth_hash.credentials&.token
    end
  end

  def authorize_access!
    return true if auth_hash && organization_member?

    flash[:error] = 'Access denied.'
    redirect_to root_path
  end

  def org_id
    ENV['GITHUB_ORGANIZATION_ID'].to_i
  end

  def organization_member?
    return true if org_id.blank?
    client.organization_member?(org_id, auth_hash.info&.nickname, headers: {
      'Cache-Control' => 'no-cache, no-store'
    })
  end
end
