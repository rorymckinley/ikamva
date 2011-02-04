class Branch < ActiveRecord::Base
  has_many :events
  has_many :members
end
