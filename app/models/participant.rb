class Participant < ActiveRecord::Base
  def self.participation_types
    [{"learner"=>"Learner"}, {"volunteer"=>"Volunteer"}]
  end
end