class CreateScheduleItems < ActiveRecord::Migration
  def change
    create_table :schedule_items do |t|
      t.string :label
      t.string :start_time
      t.references :hackathon

      t.timestamps
    end
    add_index :schedule_items, :hackathon_id
  end
end
