class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :pname

      t.timestamps
    end
  end
end
