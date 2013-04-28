class CreateBuddyData < ActiveRecord::Migration
  def change
    create_table :buddy_data do |t|
      t.string :name
      t.string :idea
      t.string :skills
      t.boolean :isIdea

      t.timestamps
    end
  end
end
