class AddPostalAddressInRoom < ActiveRecord::Migration
  def change
  	add_column :rooms, :postal_address, :string
  end
end
