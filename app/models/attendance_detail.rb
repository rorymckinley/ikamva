class AttendanceDetail < ActiveRecord::Base
  belongs_to :participant

  before_save :calculate_status

  private
  def calculate_status
    self.status = 'full'
  end
end
