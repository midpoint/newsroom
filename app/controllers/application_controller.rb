# frozen_string_literal: true

require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :json
  before_action :verify_requested_format!

  before_action :authenticate_user!, :set_raven_context

  private

  def authenticate_user!
    if !user_signed_in?
      redirect_to user_github_omniauth_authorize_path
    end
  end

  def set_raven_context
    Raven.user_context(id: current_user.id) if user_signed_in?
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
