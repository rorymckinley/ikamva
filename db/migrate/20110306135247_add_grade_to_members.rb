class AddGradeToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :grade, :integer
  end

  def self.down
    remove_column :members, :grade
  end
end
