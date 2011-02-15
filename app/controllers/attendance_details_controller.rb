class AttendanceDetailsController < ApplicationController
  def new
    @branch = Branch.find(params[:branch_id])
    @event = Event.find(params[:event_id])
  end

  def create
    event = Event.find(params[:event_id])
    branch = Branch.find(params[:branch_id])

    # TODO All of this must be reaftored into the model
    begin
      member = Member.find(params[:member][:id])
    rescue
      flash[:error] = "No member with ID of #{params[:member]["id"]}"
      redirect_to new_branch_event_attendance_detail_path(branch, event)
      return
    end

    if event.members.include? member
      redirect_to new_branch_event_attendance_detail_path(branch, event)
      flash[:error] = "Attendance already captured for member with ID #{member.id}"
      return
    end

    attendance_detail = event.attendance_details.create :member_id => member.id, :status => params[:attendance_detail]["status"]
    flash[:attendance_detail] = "#{member.first_name} #{member.surname} has #{attendance_detail.status} credit"
    redirect_to new_branch_event_attendance_detail_path(branch, event)
  end

  def index
    @branch = Branch.find(params[:branch_id])
    @event = Event.find(params[:event_id])
  end

  def edit
    @branch = Branch.find(params[:branch_id])
    @event = Event.find(params[:event_id])
    @attendance_detail = AttendanceDetail.find(params[:id])
  end

  def update
    AttendanceDetail.find(params[:id]).update_attributes! params[:attendance_detail]
    flash[:attendance_detail] = "Attendance Detail updated"
    redirect_to branch_event_attendance_details_path(Branch.find(params[:branch_id]), Event.find(params[:event_id]))
  end
end
