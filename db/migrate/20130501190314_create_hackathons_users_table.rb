class CreateHackathonsUsersTable < ActiveRecord::Migration
  def up
    create_table :hackathons_users, :id => false do |t|
      t.references :hackathon
      t.references :user
    end
    add_index :hackathons_users, [:hackathon_id, :user_id]
    add_index :hackathons_users, [:user_id, :hackathon_id]
  end

  def down
    drop_table :hackathons_users
  end
end
