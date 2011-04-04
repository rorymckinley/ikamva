class Member < ActiveRecord::Base
  has_many :attendance_details
  def self.participation_types
    [{"learner"=>"Learner"}, {"volunteer"=>"Volunteer"}]
  end
  def attendance_total
    attendance_details.inject(0.0) { |total, attendance_detail| total + (attendance_detail.status == "full" ? 1.0 : 0.5) }
  end
end
