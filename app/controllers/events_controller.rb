class EventsController < ApplicationController
  def new
    @purposes = Event.event_purposes
  end

  def create
    Event.create! params[:event].merge "branch_id" => params[:branch_id]
    flash[:event] = "Event created"
    redirect_to branch_events_path(Branch.find(params[:branch_id]))
  end
end
