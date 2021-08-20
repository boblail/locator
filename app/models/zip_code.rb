class ZipCode < ApplicationRecord
  self.primary_key = :zip

  belongs_to :state, foreign_key: :state_fips
  belongs_to :county, foreign_key: :county_fips
end
