class AttendanceDetailsController < ApplicationController
  def new
    @branch = Branch.find(params[:branch_id])
    @event = Event.find(params[:event_id])
  end

  def create
    member = Member.find(:first, :conditions => { :card_number => params[:member]["card_number"]})
    event = Event.find(params[:event_id])
    branch = Branch.find(params[:branch_id])

    unless member
      flash[:error] = "No member with card number #{params[:member]["card_number"]}"
      redirect_to new_branch_event_attendance_detail_path(branch, event)
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
