class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy, :get_house_rules]
  before_action :authenticate_user!, except: [:show]

  def index
    @rooms = current_user.rooms
  end

  def show
    @photos = @room.photos
    @defaultruleroom = DefaultRuleRoom.where(room: @room)
    @booked = Reservation.where("room_id = ? AND user_id = ?", @room.id, current_user.id).present?  if current_user

    @reviews = @room.reviews
    @hasReview = @reviews.find_by(user_id: current_user.id) if current_user
  end

  def new
    @room = current_user.rooms.build
    DefaultRule.all.map{|rule| @room.default_rules << rule}
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save

      if params[:images] 
        params[:images].each do |image|
          @room.photos.create(image: image)
        end
      end

      @photos = @room.photos
      RoomMailer.add_room(@room).deliver
      redirect_to @room, notice: "You successfully listed your space"
    else
      flash[:alert] = @room.errors.full_messages
      render :new
    end
  end

  def edit
    @place = Place.find(@room.location)
    if current_user.id == @room.user.id
      @photos = @room.photos
    else
      redirect_to root_path, notice: "You are not authorized!!!"
    end
  end

  def update
    if @room.update!(room_params)
      if params[:images]
        params[:images].each do |image|
          @room.photos.create(image: image)
        end
      end

      redirect_to @room, notice: "Your successfully updated your listing!"
    else
      flash[:alert] = "Please provide all information for this room."
      render :edit

    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_path
  end

  def get_house_rules
    @default_rules_rooms = @room.default_rule_rooms
    @aditional_rules = @room.house_rules

    respond_to do |format|
      format.js
    end
  end

  private
    def set_room
      @room = Room.find(params[:id]) 
    end

    def room_params
      params.require(:room).permit(:home_type, :room_type, :accommodate, :bed_room, 
        :bath_room, :listing_name, :summary, :address, :is_tv, :is_kitchen, :is_air, 
        :is_heating, :is_internet, :city, :is_fridge, :is_generator, :is_ups, :is_studytable, :is_iron, :is_microwave, :is_sepentrance, :is_parking, :is_food, :price, :active, :latitude, :longitude, :location, 
        :nightly_enabled, :weekly_price, :weekly_enabled, :monthly_price, :monthly_enabled,
        :postal_address, :photos_attributes => [
          :id,
          :image,
          :_destroy
        ], :default_rule_rooms_attributes =>[
          :id,
          :default_rule_id,
          :answer,
          :_destroy
        ], :house_rules_attributes => [
          :id,
          :title,
          :_destroy
        ])
    end
end
