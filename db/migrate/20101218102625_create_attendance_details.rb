class CreateAttendanceDetails < ActiveRecord::Migration
  def self.up
    create_table :attendance_details do |t|
      t.references :event
      t.references :participant
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :attendance_details
  end
end
