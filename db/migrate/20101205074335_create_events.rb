class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :purpose
      t.references :branch
      t.datetime :start
      t.datetime :end
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
