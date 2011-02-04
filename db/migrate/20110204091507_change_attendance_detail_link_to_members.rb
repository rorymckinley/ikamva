class ChangeAttendanceDetailLinkToMembers < ActiveRecord::Migration
  def self.up
    rename_column :attendance_details, :participant_id, :member_id
  end

  def self.down
    rename_column :attendance_details, :member_id, :participant_id
  end
end
