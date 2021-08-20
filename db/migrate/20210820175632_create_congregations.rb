class CreateCongregations < ActiveRecord::Migration[6.1]
  def change
    create_table :congregations do |t|
      t.string :name
      t.integer :district_id
      t.string :district
      t.string :status
      t.string :website
      t.string :city
      t.string :state_abbreviation
      t.integer :county_fips
    end
  end
end
