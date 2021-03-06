class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate

  protected

  def authenticate
    return true if Rails.env == 'development'
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['username'] && password == ENV['password']
    end
  end
end
