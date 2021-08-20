class CreateZipCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :zip_codes, primary_key: :zip do |t|
      t.string :city
      t.integer :state_fips
      t.integer :county_fips
    end
  end
end
