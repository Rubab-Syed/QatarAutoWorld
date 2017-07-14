class AddColumnsInPlaces < ActiveRecord::Migration[5.0]
  def change
  	add_column :places, :locality, :integer
  	add_column :places, :city_name, :string
  end
end
