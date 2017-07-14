class CreateDefaultRules < ActiveRecord::Migration[5.0]
  def change
    create_table :default_rules do |t|
    	t.string :title
    	
      t.timestamps
    end
  end
end
