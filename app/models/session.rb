class Session < ActiveRecord::Base
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
