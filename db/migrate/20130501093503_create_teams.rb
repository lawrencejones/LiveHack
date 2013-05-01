class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.references :hackathon
      t.references :users
      t.references :proposals

      t.timestamps
    end
    add_index :teams, :hackathon_id
    add_index :teams, :users_id
    add_index :teams, :proposals_id
  end
end
