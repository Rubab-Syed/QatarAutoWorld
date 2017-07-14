class AddBirthDayToUser < ActiveRecord::Migration
  def change
    add_column :users, :birth_day, :datetime
  end
end
