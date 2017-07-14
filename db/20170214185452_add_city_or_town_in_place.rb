class AddCityOrTownInPlace < ActiveRecord::Migration
  def change
  	add_column :places, :_type, :integer, :default => 1
  end
end
