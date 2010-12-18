class CreateAttendanceDetails < ActiveRecord::Migration
  def self.up
    create_table :attendance_details do |t|
      t.references :branch
      t.references :event
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :attendance_details
  end
end
