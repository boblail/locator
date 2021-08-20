class CreateStates < ActiveRecord::Migration[6.1]
  def change
    create_table :states, primary_key: :fips do |t|
      t.string :abbreviation
      t.string :name
    end
  end
end
