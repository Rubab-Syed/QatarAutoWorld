class PlacesController < ApplicationController
  def get_place
    @place = Place.find(params[:id])
  end
end
