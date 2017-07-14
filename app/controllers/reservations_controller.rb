class ReservationsController < ApplicationController
  before_action :authenticate_user!, except: [:notify, :create, :preload]
  before_action :set_reservation, only: [:approve, :reject, :complete]
  
  def preload # For start_date
    room = Room.find(params[:room_id])
    today = Date.today
    reservations = room.reservations.where("start_date >= ? OR end_date >= ?", today, today)
    
    render json: reservations
  end
  
  def preview 
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
    
    output = {
      conflict: is_conflict(start_date, end_date)	
    }
    
    render json: output
  end
  
  def create
    respond_to do |format|
      @success = false
      if current_user.present?
        @reservation = current_user.reservations.create(reservation_params)
        if @reservation
          send_sms_to_host
          send_sms_to_guest
          ReservationMailer.room_reservation(@reservation, @message).deliver
          @success = true	
        end
      end	
      format.html { redirect_to trips_history_path }
      format.js
    end
    # we don't need to update status because default status is 0 i.e request sent 
    # @reservation.update_attributes status: 0 
    
    # We need some online payment method in between
    # 	if @reservation
    # 		# send request to PayPal
    # 		values = {
    # 			business: 'safarnov-facilitator@gmail.com',
    # 			cmd: '_xclick',
    # 			upload: 1,
    # 			notify_url: notify_path,
    # 			amount: @reservation.total,
    # 			item_name: @reservation.room.listing_name,
    # 			item_number: @reservation.id ,
    # 			quantity: '1',
    # 			return: trips_history_path
    # 		}
    # 		redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
    # 	else
    # 		redirect_to @reservation.room, alert: "Oops, something went wrong..."
    # end
  end
  protect_from_forgery except: [:notify]
  
  def notify
    params.permit!
    status = params[:payment_status]
    reservation = Reservation.find(params[:item_number])
    
    if status == "Completed"
      reservation.update_attributes status: true
    else
      reservation.destroy
    end
    render nothing: true
  end
  
  protect_from_forgery except: [:trips_history]
  def trips_history
    @trips = current_user.reservations.where("status = ?", 1)
  end
  
  def received_reservations
    @rooms = current_user.rooms
  end
  
  # approve sets status to payment_pending
  def approve
    @reservation.update_attribute(:status, 1)
    ReservationMailer.approve_request(@reservation).deliver
    redirect_to received_reservations_path + "#" + params[:current_tab]
  end
  
  def reject
    @reservation.update_attribute(:status, 3)
    redirect_to received_reservations_path + "#" + params[:current_tab]
  end

  def complete
    @reservation.update_attribute(:status, 4)
    redirect_to received_reservations_path + "#" + params[:current_tab]
  end

  private
  
  def send_sms_to_host
    sns = Aws::SNS::Client.new
    num_days = @reservation.num_days
    num_weeks = @reservation.num_weeks
    num_months = @reservation.num_months
    if num_days.present?
      @num = num_days
      @periods = "day(s)"
    elsif num_weeks.present?
      @num = num_weeks
      @periods = "week(s)"
    elsif num_months.present?
      @num = num_months
      @periods = "month(s)"
    end

    @message = "Dear #{@reservation.room.user.fullname},

#{@reservation.user.fullname} wants to book your listing '#{@reservation.room.listing_name}' from #{@reservation.start_date.to_s.split[0]} for #{@num} #{@periods}."
    guest_num   = @reservation.user.phone_number.to_s
    phone_guest = Phonelib.parse(guest_num)
    if phone_guest.valid? && phone_guest.full_e164.present?
      @message = @message + "

Details of Mehmaan:
Phone number: #{@reservation.user.phone_number} "
    end
   
    host_num   = @reservation.room.user.phone_number.to_s
    phone_host = Phonelib.parse(host_num)
    if phone_host.valid? && phone_host.full_e164.present?
      sns.publish({phone_number: phone_host.full_e164,
                    message: @message})
      sns.publish({phone_number: '+923456890083',
                    message: @message})                 #Owais
      sns.publish({phone_number: '+923200514147',
                    message: @message})                 #Azeem
    end
  end

  def send_sms_to_guest
    sns = Aws::SNS::Client.new
    message = "Dear #{@reservation.user.fullname},

You have booked #{@reservation.room.user.fullname}'s listing '#{@reservation.room.listing_name}' from #{@reservation.start_date.to_s.split[0]} for #{@num} #{@periods}."
    host_num   = @reservation.room.user.phone_number.to_s
    phone_host = Phonelib.parse(host_num)
    if phone_host.valid? && phone_host.full_e164.present?
      message = message + "

Details of Mezbaan:
Phone number: #{@reservation.room.user.phone_number} "
    end
    guest_num   = @reservation.user.phone_number.to_s
    phone_guest = Phonelib.parse(guest_num)
    if phone_guest.valid? && phone_guest.full_e164.present?
       sns.publish({phone_number: phone_guest.full_e164,
                    message: message})
    end
  end

  def is_conflict(start_date, end_date)
    room = Room.find(params[:room_id])
    
    check = room.reservations.where("? < start_date AND end_date < ?", start_date, end_date)
    check.size > 0? true : false
  end
  
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end
  
  def reservation_params
    params.require(:reservation).permit(
      :start_date, :end_date, :price, :total, :room_id,
      :num_days, :num_weeks, :num_months, :customer_agree 
    )
  end

end
