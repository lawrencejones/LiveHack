class AddDescToTeams < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.text :description
    end
  end
end
