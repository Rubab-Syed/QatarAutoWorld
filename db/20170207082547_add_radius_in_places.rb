class AddRadiusInPlaces < ActiveRecord::Migration
  def change
  	add_column :places, :radius, :integer
  end
end
