class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.string :name
      t.text :desc
      t.string :skills
      t.references :team

      t.timestamps
    end
    add_index :proposals, :team_id
  end
end
