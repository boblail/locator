class CreateCounties < ActiveRecord::Migration[6.1]
  def change
    create_table :counties, primary_key: :fips do |t|
      t.integer :state_fips
      t.string :name
    end
  end
end
