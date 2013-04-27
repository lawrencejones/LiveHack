class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :fname
      t.string :lname

      t.timestamps
    end
  end
end
