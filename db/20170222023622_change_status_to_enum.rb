class ChangeStatusToEnum < ActiveRecord::Migration
  def change
  	remove_column :reservations, :status
    add_column :reservations, :status, :integer, default: 0
  	# change_column :reservations, :status, :integer
  end
end
