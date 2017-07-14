class AddCityAndStatusInUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :city, :string
  	add_column :users, :status, :integer
  	add_column :users, :description_of_work, :text
  end
end
