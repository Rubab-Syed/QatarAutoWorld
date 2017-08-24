class AddNumberToBreakdown < ActiveRecord::Migration[5.0]
  def change
    add_column :breakdowns, :phone_number, :string
  end
end
