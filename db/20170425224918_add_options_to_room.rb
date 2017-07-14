class AddOptionsToRoom < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :city, :string
    add_column :rooms, :is_generator, :boolean
    add_column :rooms, :is_fridge, :boolean
    add_column :rooms, :is_ups, :boolean
    add_column :rooms, :is_iron, :boolean
    add_column :rooms, :is_microwave, :boolean
    add_column :rooms, :is_studytable, :boolean
    add_column :rooms, :is_sepentrance, :boolean
    add_column :rooms, :is_parking, :boolean
  end
end
