class Event < ActiveRecord::Base
  belongs_to :branch

  def self.event_purposes
    [
      [ 'Branchcom Meeting', 'branchcom' ],
      [ 'Excursion', 'excursion' ],
      [ 'Holiday Programme', 'holiday' ],
      [ 'Homework', 'homework' ],
      [ 'Tutorial', 'tutorial' ],
      [ 'Volunteer Training', 'training' ],
      [ 'Workshop', 'workshop' ]
    ]
  end
end
