class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :email
      t.string :github_email
      t.string :tags
      t.boolean :signed_up
      t.references :hackathons
      t.references :teams

      t.timestamps
    end
    add_index :users, :hackathon_id
    add_index :users, :team_id
  end
end
