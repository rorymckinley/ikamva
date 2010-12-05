class EventsController < ApplicationController
  def new
    @types = Event.session_types
  end

  def create
    Event.create! params[:event].merge "branch_id" => params[:branch_id]
    render :text => "", :head => :ok
  end
end
