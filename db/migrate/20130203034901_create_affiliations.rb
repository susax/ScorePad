class CreateAffiliations < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.references :team
      t.references :player

      t.timestamps
    end
  end
end
