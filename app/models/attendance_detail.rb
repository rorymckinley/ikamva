class AttendanceDetail < ActiveRecord::Base
  belongs_to :member
  belongs_to :event

  before_create :calculate_status

  private
  def calculate_status
    return unless status.blank?

    self.status = Time.now > event.late_after ? 'partial' : 'full'
  end
end
