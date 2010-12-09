class Event < ActiveRecord::Base
  belongs_to :branch

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
end
