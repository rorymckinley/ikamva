class Event < ActiveRecord::Base
  belongs_to :branch
  has_many :attendance_details
  has_many :members, :through => :attendance_details

  def self.event_purposes
    [
      { 'branchcom' => 'Branchcom Meeting' },
      { 'careers' => 'Careers Indaba'},
      { 'computer' => 'Computer Class'},
      { 'excursion' => 'Excursion' },
      { 'holiday' => 'Holiday Programme' },
      { 'homework' => 'Homework' },
      { 'parents' => 'Parents Meeting'},
      { 'prize' => 'Prize Giving'},
      { 'talent' => 'Talent Show'},
      { 'tutorial' => 'Tutorial' },
      { 'training' => 'Volunteer Training' },
      { 'workshop' => 'Workshop' }
    ]
  end

  def late_after
    start + 20.minutes
  end
end
