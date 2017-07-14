class AddFoodToRoom < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :is_food, :boolean 
  end
end
