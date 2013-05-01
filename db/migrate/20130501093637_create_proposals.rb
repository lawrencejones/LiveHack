class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.string :desc
      t.string :name
      t.string :skills
      t.references :team
      t.references :hackathon

      t.timestamps
    end
    add_index :proposals, :team_id
    add_index :proposals, :hackathon_id
  end
end
