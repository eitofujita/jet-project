class PostsController < ApplicationController
  before_action :require_authentication
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = policy_scope(Post)
      .with_attached_image
      .includes(:user, :likes, comments: :user)
      .recent
  end

  def show
    authorize @post
    @comment = Comment.new
    @comments = @post.comments.includes(:user).oldest_first
  end

  def new
    @post = current_user.posts.build
    authorize @post
  end

  def edit
    authorize @post
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize @post

    if @post.save
      redirect_to @post, notice: "Публикация создана"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @post

    if @post.update(post_params)
      redirect_to @post, notice: "Публикация обновлена", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @post
    @post.destroy!
    redirect_to root_path, notice: "Публикация удалена", status: :see_other
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:caption, :image)
  end
end
