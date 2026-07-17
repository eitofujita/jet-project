class UsersController < ApplicationController
  before_action :require_authentication, only: :show

  def new
    redirect_to root_path if signed_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      reset_session
      session[:user_id] = @user.id
      redirect_to root_path, notice: "アカウントを作成しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    @user = User.find(params[:id])
    authorize @user
    @posts = @user.posts.with_attached_image.includes(:user, :likes, :comments).recent
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
