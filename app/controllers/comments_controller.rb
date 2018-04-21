class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.restaurant, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def summary
    @comments = Comment.where(user_id: current_user.id)
    @user_votes = UserVote.where(user_id: current_user.id)
    @favorite_restaurants = Favorite.where(user_id: current_user.id, favorite_res: 'true')
  end

  def favorite
    if current_user.favorites.find_by(restaurant_id: params[:id].to_i)
      current_user.favorites.find_by(restaurant_id: params[:id].to_i).update_column(:favorite_res, params[:checked])
    else
      current_user.favorites.create(restaurant_id: params[:id].to_i, favorite_res: params[:checked])
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body, :user_id, :restaurant_id)
    end
end
