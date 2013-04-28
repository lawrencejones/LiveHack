class CreateHackathons < ActiveRecord::Migration
  def change
    create_table :hackathons do |t|
      t.string :name
      t.string :desc
      t.string :start
      t.string :end
      t.string :location
      t.string :scheduleItems

      t.timestamps
    end
  end
end
