class County < ApplicationRecord
  self.primary_key = :fips

  belongs_to :state, foreign_key: :state_fips
end
