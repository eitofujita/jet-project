class LikesController < ApplicationController
  before_action :require_authentication
  before_action :set_post

  def create
    authorize @post, :show?
    @like = @post.likes.find_or_initialize_by(user: current_user)
    @like.save!
    respond_with_post
  rescue ActiveRecord::RecordNotUnique
    @like = @post.likes.find_by!(user: current_user)
    respond_with_post
  end

  def destroy
    authorize @post, :show?
    @post.likes.find_by(user: current_user)&.destroy!
    respond_with_post
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def respond_with_post
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post, status: :see_other }
    end
  end
end
