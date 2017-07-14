class AddAdditionalFildsInListing < ActiveRecord::Migration[5.0]
  def change
  	add_column :rooms, :nightly_enabled, :boolean, :default => false
  	add_column :rooms, :weekly_price, :integer
  	add_column :rooms, :weekly_enabled, :boolean, :default => false
  	add_column :rooms, :monthly_price, :integer
  	add_column :rooms, :monthly_enabled, :boolean, :default => false
  end
end
