class SessionsController < ApplicationController
  def new
    @types = Session.session_types
  end

  def create
    Session.create! params[:session].merge "branch_id" => params[:branch_id]
    render :text => "", :head => :ok
  end
end
