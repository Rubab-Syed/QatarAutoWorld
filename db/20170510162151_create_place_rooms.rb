class CreatePlaceRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :place_rooms do |t|
    	t.integer :room_id
    	t.integer :place_id
    	
      t.timestamps
    end
  end
end
