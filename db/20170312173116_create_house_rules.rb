class CreateHouseRules < ActiveRecord::Migration[5.0]
  def change
    create_table :house_rules do |t|
    	t.string :title
    	t.string :description
    	t.integer :room_id
    	
      t.timestamps
    end
  end
end
