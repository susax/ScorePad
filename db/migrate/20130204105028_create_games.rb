class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :top_team_id
      t.integer :bottom_team_id
      t.datetime :playball_datetime
      t.string :stadium

      t.timestamps
    end
  end
end
