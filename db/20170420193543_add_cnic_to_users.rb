class AddCnicToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :cnic, :string
  end
end
