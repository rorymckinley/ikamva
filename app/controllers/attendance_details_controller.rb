class AttendanceDetailsController < ApplicationController
  def new
    @branch = Branch.find(params[:branch_id])
    @event = Event.find(params[:event_id])
  end

  def create
    participant = Participant.find(:first, :conditions => { :card_number => params[:participant]["card_number"]})
    event = Event.find(params[:event_id])
    event.attendance_details.create :participant_id => participant.id, :status => params[:attendance_detail]["status"]
    render :text => ''
  end
end
