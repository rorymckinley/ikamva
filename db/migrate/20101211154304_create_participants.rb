class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.string :name
      t.string :card_number
      t.string :participation
      t.references :branch
      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
