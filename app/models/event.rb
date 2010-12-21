class Event < ActiveRecord::Base
  belongs_to :branch
  has_many :attendance_details
  has_many :participants, :through => :attendance_details

  def self.event_purposes
    [
      { 'branchcom' => 'Branchcom Meeting' },
      { 'excursion' => 'Excursion' },
      { 'holiday' => 'Holiday Programme' },
      { 'homework' => 'Homework' },
      { 'tutorial' => 'Tutorial' },
      { 'training' => 'Volunteer Training' },
      { 'workshop' => 'Workshop' }
    ]
  end

  def late_after
    start + 15.minutes
  end
end
