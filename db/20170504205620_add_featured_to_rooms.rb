class AddFeaturedToRooms < ActiveRecord::Migration[5.0]
  def change
  	add_column :rooms, :is_featured, :boolean
  end
end
