class ParticipantsController < ApplicationController
  def new
    @branch = Branch.find(params[:branch_id])
    @participation_types = Participant.participation_types
  end

  def create
    Branch.find(params[:branch_id]).participants.create! params[:participant]
    flash[:participant] = 'Participant created'
    redirect_to branch_participants_path(:branch_id => params[:branch_id])
  end

  def index
    @participation_types = Participant.participation_types
    @participants = Branch.find(params[:branch_id]).participants
  end
end
