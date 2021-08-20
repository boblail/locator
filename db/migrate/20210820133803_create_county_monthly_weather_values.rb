class CreateCountyMonthlyWeatherValues < ActiveRecord::Migration[6.1]
  def change
    create_table :county_monthly_weather_values do |t|
      t.integer :fips
      t.date :month
      t.numeric :min_temperature
      t.numeric :max_temperature

      t.index %i[fips month], unique: true
    end
  end
end
