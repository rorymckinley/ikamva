class Session < ActiveRecord::Base
  belongs_to :branch

  def self.session_types
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
