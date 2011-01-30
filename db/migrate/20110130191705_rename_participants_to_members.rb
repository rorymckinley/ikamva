class RenameParticipantsToMembers < ActiveRecord::Migration
  def self.up
    rename_table :participants, :members
  end

  def self.down
  end
end
