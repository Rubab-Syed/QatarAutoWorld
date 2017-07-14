class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :room

  enum status: [ :request_sent, :payment_pending, :payment_confirmed, :rejected, :completed]
end
