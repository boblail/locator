class CountiesController < ApplicationController
  def show
    @county = County.find(params.require(:fips))
  end
end
