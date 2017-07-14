class AddPaymentTypeInReservation < ActiveRecord::Migration[5.0]
  def change
	add_column :reservations, :reservation_time, :string
    add_column :reservations, :num_days, :integer
    add_column :reservations, :num_weeks, :integer
    add_column :reservations, :num_months, :integer
    add_column :reservations, :customer_agree, :boolean
  end
end
