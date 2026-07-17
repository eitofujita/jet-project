class FollowsController < ApplicationController
  before_action :require_authentication
  before_action :set_user

  def create
    authorize @user, :follow?
    current_user.active_follows.find_or_create_by!(followed: @user)
    redirect_to @user, notice: "#{@user.username}をフォローしました", status: :see_other
  rescue ActiveRecord::RecordNotUnique
    redirect_to @user, status: :see_other
  end

  def destroy
    authorize @user, :follow?
    current_user.active_follows.find_by(followed: @user)&.destroy!
    redirect_to @user, notice: "#{@user.username}のフォローを解除しました", status: :see_other
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
