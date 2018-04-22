class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index, :vote_history, :search]
  skip_before_action :verify_authenticity_token
  # GET /restaurants
  # GET /restaurants.json
  def index
    @restaurants = Restaurant.all
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
    if current_user
      @comment = Comment.new(user_id: current_user.id, restaurant_id:  @restaurant.id)
      @comments = Comment.where(restaurant_id: @restaurant.id)
    end
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    respond_to do |format|
      @restaurant.name = restaurant_params[:name] if restaurant_params[:name]
      @restaurant.address = restaurant_params[:address] if restaurant_params[:address]
      @restaurant.city = restaurant_params[:city] if restaurant_params[:city]
      if @restaurant.save
        create_user_votes
        format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    @restaurants = Restaurant.where("name like ? AND city like ? AND address like ?",
                                    "%#{params['restaurant']['name']}%", "%#{params['restaurant']['city']}%", "%#{params['restaurant']['address']}%")
    respond_to do |format|
      format.html { render :index }
    end
  end

  def vote_history
    @user_votes = UserVote.where(restaurant_id: params[:id].to_i)
  end

  private

  def create_user_votes
    if params[:restaurant][:upvote]
      if current_user.user_votes.find_by(restaurant_id: @restaurant.id)
        current_user.user_votes.find_by(restaurant_id: @restaurant.id).increment!(:upvote)
      else
        current_user.user_votes.create(restaurant_id: @restaurant.id, upvote: 1)
      end
    elsif params[:restaurant][:downvote]
      if current_user.user_votes.find_by(restaurant_id: @restaurant.id)
        current_user.user_votes.find_by(restaurant_id: @restaurant.id).increment!(:downvote)
      else
        current_user.user_votes.create(restaurant_id: @restaurant.id, downvote: 1)
      end
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :address, :city, :upvote, :downvote)
    end
end
