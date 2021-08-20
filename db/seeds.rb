
require "csv"

# Dataset: 2018 FIPS Codes
# Source: U.S. Census Bureau 
# URL: https://www.census.gov/geographies/reference-files/2018/demo/popest/2018-fips.html
if County.count.zero?
  County.insert_all(
    CSV.parse(Rails.root.join("data", "all-geocodes-v2018.csv").read, headers: true)
      .map do |row|
        {
          fips: (row.fetch("State Code (FIPS)") + row.fetch("County Code (FIPS)")).to_i,
          state_fips: row.fetch("State Code (FIPS)").to_i,
          name: row.fetch("Area Name")
        }
      end
  )
end

# Dataset: FIPS State Codes
# Source: U.S. Census Bureau 
# URL: https://data.world/uscensusbureau/fips-state-codes
if State.count.zero?
  State.insert_all(
    CSV.parse(Rails.root.join("data", "state.txt").read, col_sep: "|", headers: true)
      .map do |row|
        {
          fips: row.fetch("STATE"),
          abbreviation: row.fetch("STUSAB"),
          name: row.fetch("STATE_NAME"),
        }
      end
  )
end

# Dataset: US Zipcode to County State to FIPS Look Up
# Source: Nic Colley
# URL: https://data.world/niccolley/us-zipcode-to-county-state
if ZipCode.count.zero?
  state_map = State.pluck(:abbreviation, :fips).to_h
  # county_by_id = County.all.index_by(&:fips)

  ZipCode.insert_all(
    CSV.parse(Rails.root.join("data", "ZIP-COUNTY-FIPS_2018-03.csv").read, headers: true)
      .map do |row|
        # county = county_by_id[row.fetch("STCOUNTYFP").to_i]
        # unless county&.name == row.fetch("COUNTYNAME")
        #   puts "#{county&.name} != #{row.fetch("COUNTYNAME")}"
        # end

        {
          zip: row.fetch("ZIP"),
          city: row.fetch("CITY"),
          state_fips: state_map.fetch(row.fetch("STATE")),
          county_fips: row.fetch("STCOUNTYFP").to_i,
        }
      end
  )
end

# Dataset: Monthly U.S. Climate Divisional Database
# Source: NOAA
# URL: https://www.ncei.noaa.gov/access/metadata/landing-page/bin/iso?id=gov.noaa.ncdc:C00005
# Time to seed 1980-onward: 2m43.342s, 1,550,393 records
if CountyMonthlyWeatherValue.count.zero?
  CountyMonthlyWeatherValue.import_climdiv_data(
    value: :max_temperature,
    path: Rails.root.join("data", "climdiv-tmaxcy-v1.0.0-20210805")
  )

  CountyMonthlyWeatherValue.import_climdiv_data(
    value: :min_temperature,
    path: Rails.root.join("data", "climdiv-tmincy-v1.0.0-20210805")
  )
end
