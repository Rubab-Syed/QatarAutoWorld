class CreateBreakdowns < ActiveRecord::Migration
  def change
    create_table :breakdowns do |t|
      t.string :date
      t.string :time
      t.integer :name
      t.timestamps null: false
    end
  end
end
