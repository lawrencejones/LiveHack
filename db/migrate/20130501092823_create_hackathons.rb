class CreateHackathons < ActiveRecord::Migration
  def change
    create_table :hackathons do |t|
      t.string :eid
      t.string :name
      t.datetime :start
      t.datetime :end
      t.string :location
      t.text :description
      t.references :users
      t.references :teams
      t.references :schedule_items
      t.references :proposals

      t.timestamps
    end
    add_index :hackathons, :users_id
    add_index :hackathons, :teams_id
    add_index :hackathons, :schedule_items_id
    add_index :hackathons, :proposals_id
  end
end
