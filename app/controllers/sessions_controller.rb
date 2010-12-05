class SessionsController < ApplicationController
  def new
    @types = Session.session_types
  end
end
