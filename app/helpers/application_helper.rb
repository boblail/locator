module ApplicationHelper
  def discomfort
    CountyMonthlyWeatherValue.group(:fips)
      .pluck(:fips, Arel.sql(<<~SQL))
        SUM(SUM(GREATEST(max_temperature - 78, 0))) OVER (PARTITION BY fips) + 
        SUM(SUM(GREATEST(32 - min_temperature, 0))) OVER (PARTITION BY fips)
      SQL
      .map { |a, b| ["%05d" % a, b.to_f] }
  end

  def heat
    CountyMonthlyWeatherValue.group(:fips)
      .pluck(:fips, Arel.sql(<<~SQL))
        SUM(SUM(GREATEST(max_temperature - 78, 0))) OVER (PARTITION BY fips)
      SQL
      .map { |a, b| ["%05d" % a, b.to_f] }
  end

  def chill
    CountyMonthlyWeatherValue.group(:fips)
      .pluck(:fips, Arel.sql(<<~SQL))
        SUM(SUM(GREATEST(32 - min_temperature, 0))) OVER (PARTITION BY fips)
      SQL
      .map { |a, b| ["%05d" % a, b.to_f] }
  end

  # zip codes? https://gist.github.com/jefffriesen/6892860
  def us_json
    # Geographies: https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html
    except_ak_hi Rails.root.join("data", "counties-albers-10m.json").read
  end

  def except_ak_hi(json)
    data = JSON.load(json)

    data["objects"]["states"]["geometries"].delete_if do |geometry|
      geometry["id"] == "02" || geometry["id"] == "15"
    end

    data["objects"]["counties"]["geometries"].delete_if do |geometry|
      geometry["id"].start_with?("02") || geometry["id"].start_with?("15")
    end

    JSON.dump(data)
  end
end
