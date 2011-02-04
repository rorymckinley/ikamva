class AddGradeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :grade, :int
  end

  def self.down
    remove_column :events, :grade
  end
end
