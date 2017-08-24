class BreakdownsController < ApplicationController
  
  def create
    respond_to do |format|
      @breakdown = Breakdown.create(breakdown_params)
      if @breakdown
          #send_sms_to_host
        #send_sms_to_guest
          #ReservationMailer.room_reservation(@reservation, @message).deliver
        @success = true	
      end
      flash[:notice] = "You have successfully made a breakdown appointment"
      format.html { redirect_to root_path }
    end
  end

  def new
    @breakdown = Breakdown.new
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
  
  def breakdown_params
    params.require(:breakdown).permit(:date, :name, :time, :phone_number)
  end

end
