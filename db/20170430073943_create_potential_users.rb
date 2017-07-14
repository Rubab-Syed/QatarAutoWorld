class CreatePotentialUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :potential_users do |t|
    	t.string :email
    	t.string :phone_number
    	
      t.timestamps
    end
  end
end
