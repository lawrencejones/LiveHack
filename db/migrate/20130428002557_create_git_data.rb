class CreateGitData < ActiveRecord::Migration
  def change
    create_table :git_data do |t|
      t.string :user
      t.string :repo
      t.string :time

      t.timestamps
    end
  end
end
