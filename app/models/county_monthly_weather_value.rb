class CountyMonthlyWeatherValue < ApplicationRecord
  class << self
    EXPECTED_ELEMENT_CODE = {
      min_temperature: 28,
      max_temperature: 27,
      avg_temperature: 2,
      precipitation: 1
    }.freeze

    # Source: county-readme.txt
    STATE_MAP = {
      "01" => "Alabama",
      "02" => "Arizona",
      "03" => "Arkansas",
      "04" => "California",
      "05" => "Colorado",
      "06" => "Connecticut",
      "07" => "Delaware",
      "08" => "Florida",
      "09" => "Georgia",
      "10" => "Idaho",
      "11" => "Illinois",
      "12" => "Indiana",
      "13" => "Iowa",
      "14" => "Kansas",
      "15" => "Kentucky",
      "16" => "Louisiana",
      "17" => "Maine",
      "18" => "Maryland",
      "19" => "Massachusetts",
      "20" => "Michigan",
      "22" => "Mississippi",
      "21" => "Minnesota",
      "23" => "Missouri",
      "24" => "Montana",
      "25" => "Nebraska",
      "26" => "Nevada",
      "27" => "New Hampshire",
      "28" => "New Jersey",
      "29" => "New Mexico",
      "30" => "New York",
      "31" => "North Carolina",
      "32" => "North Dakota",
      "33" => "Ohio",
      "34" => "Oklahoma",
      "35" => "Oregon",
      "36" => "Pennsylvania",
      "37" => "Rhode Island",
      "38" => "South Carolina",
      "39" => "South Dakota",
      "40" => "Tennessee",
      "41" => "Texas",
      "42" => "Utah",
      "43" => "Vermont",
      "44" => "Virginia",
      "45" => "Washington",
      "46" => "West Virginia",
      "47" => "Wisconsin",
      "48" => "Wyoming",
    }.freeze

    NULL_VALUE = "-99.90".freeze

    private def state_code_to_state_fips
      @state_code_to_state_fips ||=
        STATE_MAP.transform_values(&State.pluck(:name, :fips).to_h.method(:fetch))
    end

    def import_climdiv_data(value:, path:)
      expected_element_code = EXPECTED_ELEMENT_CODE.fetch(value)

      rows = path.read.lines.each_with_object([]) do |row, rows|
        key, *values_by_month = row.split
        year = key[7..10].to_i
        next if year < 1980

        element = key[5..6].to_i
        unless element == expected_element_code
          puts "\e[33mWARN:\e[0m expected element to be #{expected_element_code}; it was #{element}"
          next
        end

        state_code = key[0..1]
        state_fips = state_code_to_state_fips[state_code]
        unless state_fips
          puts "\e[33mWARN:\e[0m unrecognized state code: #{state_code.inspect}"
          next
        end
        state = state_code_to_state_fips.fetch(key[0..1])
        fips = ["%02d" % state_fips, key[2..4]].join.to_i

        values_by_month.each_with_index do |v, i|
          next if v == NULL_VALUE
          rows.push(fips: fips, month: Date.new(year, i+1, 1), value => v)
        end
      end

      batches = rows.in_groups_of(500, false)

      progressbar = ProgressBar.create(
        title: "#{path.basename}",
        total: batches.length
      )

      batches.each do |batch|
        upsert_all(batch, unique_by: :index_county_monthly_weather_values_on_fips_and_month)
        progressbar.increment
      end

      progressbar.finish
    end
  end
end
