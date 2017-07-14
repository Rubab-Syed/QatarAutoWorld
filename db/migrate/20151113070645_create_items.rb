class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :price
      t.integer :type
      t.integer :description
      t.timestamps null: false
    end
  end
end
