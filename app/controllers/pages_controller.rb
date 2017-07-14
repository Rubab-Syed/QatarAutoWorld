class PagesController < ApplicationController
  def home
    
  end
  
  def how_it_works
  end
  
  def search
    redirect_to display_listings_url(place: :lhr, search: params[:location])
  end

  def send_us_email
    NotificationMailer.send_email_to_team(params[:full_name],params[:contact_number],
                                          params[:email_address],params[:message]).deliver
    respond_to do |format|
      format.js {}
    end
  end
  
  def host_earning
  end

  # GET /display
  def display_listings
    #HACK: else change structure
    if params[:search].present? && params[:place] == "lhr"
      if params[:search] == "1"
        @listings = Room.where(active: true).order(created_at: :desc)
      else
        @listings = Room.where(active: true, location: params[:search]).order(created_at: :desc)
      end
      @listings_title = "lahore"
      @listings_pic   = "lahore.jpg"
    elsif params[:place] == "lhr"
      @listings = Room.where(active: true, home_type: ['House', 'Apartment', 'GuestHouse'], location: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]).order(created_at: :desc)
      @listings_title = "lahore"
      @listings_pic   = "lahore.jpg"
    elsif params[:place] == "isl"
      @listings_title = "islamabad"
      @listings_pic   = "monument.jpg"
    elsif params[:place] == "north"
      @listings = Room.where(active: true, home_type: ['House', 'Apartment', 'GuestHouse'], location: [73]).order(created_at: :desc)
      @listings_title = "northern areas"
      @listings_pic   = "hunza.jpg"
    end
    
  end

  def pages_params
    params.require(:pages).permit(:place, :full_name, :message, :email_address, :contact_number)
  end
end
