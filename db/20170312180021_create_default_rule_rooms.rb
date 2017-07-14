class CreateDefaultRuleRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :default_rule_rooms do |t|
    	t.integer :room_id
    	t.integer :default_rule_id
    	t.boolean :answer
    	
      t.timestamps
    end
  end
end
