class AddRegDateToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :registration_date, :datetime 
  end

  def self.down
    remove_column :members, :registration_date
  end
end
