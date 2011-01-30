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
    @branch = Branch.find(params[:branch_id])
    @participation_types = Participant.participation_types
    @participants = @branch.participants
  end

  def edit
    @branch = Branch.find(params[:branch_id])
    @participant = Participant.find(params[:id])
    @participation_types = Participant.participation_types
  end

  def update
    Participant.find(params[:id]).update_attributes! params[:participant]
    flash[:participant] = 'Participant Updated'
    redirect_to branch_participants_path(Branch.find(params[:branch_id]))
  end
end
