class CreateScheduleItems < ActiveRecord::Migration
  def change
    create_table :schedule_items do |t|
      t.string :name
      t.string :iconUrl
      t.string :time
      t.boolean :isMajor

      t.timestamps
    end
  end
end
