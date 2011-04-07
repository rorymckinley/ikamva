class EventsController < ApplicationController
  def new
    @purposes = Event.event_purposes
    render :layout => 'event'
  end

  def create
    Event.create! params[:event].merge "branch_id" => params[:branch_id]
    flash[:event] = "Event created"
    redirect_to branch_events_path(Branch.find(params[:branch_id]))
  end

  def index
    @branch = Branch.find(params[:branch_id])
    @events = @branch.events
  end

  def edit
    @purposes = Event.event_purposes
    @branch = Branch.find(params[:branch_id])
    @event = Event.find(params[:id])
    render :layout => 'event'
  end

  def update
    Event.find(params[:id]).update_attributes! params[:event]
    flash[:event] = "Event Updated"
    redirect_to branch_events_path(Branch.find(params[:branch_id]))
  end
end
