class Congregation < ApplicationRecord
  belongs_to :county, foreign_key: :county_fips
end
