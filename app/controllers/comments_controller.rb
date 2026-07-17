class CommentsController < ApplicationController
  before_action :require_authentication
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    authorize @comment

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "コメントしました" }
      end
    else
      redirect_to @post, alert: @comment.errors.full_messages.to_sentence, status: :see_other
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    authorize @comment
    @comment.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post, notice: "コメントを削除しました", status: :see_other }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
