# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery
  may_control_access

  def current_user
    @current_user ||= User.send((params[:user] || 'guest').to_sym)
  end
end
