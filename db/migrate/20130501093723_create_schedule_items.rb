class CreateScheduleItems < ActiveRecord::Migration
  def change
    create_table :schedule_items do |t|
      t.string :label
      t.references :hackathon
      t.datetime :start_time
      t.icon_class :icon_class

      t.timestamps
    end
    add_index :schedule_items, :hackathon_id
  end
end
