class UsersController < ApplicationController
  before_action :require_authentication, only: %i[index show followers following]
  before_action :set_user, only: %i[show followers following]

  def index
    @users = policy_scope(User)
      .where.not(id: current_user.id)
      .includes(:posts, :followers)
      .order(:username)
    load_followed_user_ids
  end

  def new
    redirect_to root_path if signed_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      reset_session
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Аккаунт создан"
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    authorize @user
    @posts = @user.posts.with_attached_image.includes(:user, :likes, :comments).recent
  end

  def followers
    authorize @user, :show?
    @users = @user.followers.includes(:posts, :followers).order(:username)
    load_followed_user_ids
  end

  def following
    authorize @user, :show?
    @users = @user.following.includes(:posts, :followers).order(:username)
    load_followed_user_ids
  end

  private

  def set_user
    @user = User.find_by_param!(params[:id])
  end

  def load_followed_user_ids
    @followed_user_ids = current_user.active_follows
      .where(followed_id: @users)
      .pluck(:followed_id)
      .to_set
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
