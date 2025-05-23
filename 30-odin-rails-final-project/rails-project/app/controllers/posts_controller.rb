class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize Post

    @posts = Post.all
  end

  def show
    authorize Post

    @post = Post.find(params[:id])
  end

  def new
    authorize Post

    @post = Post.new
  end

  def create
    authorize Post

    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])

    authorize @post
  end

  def update
    @post = Post.find(params[:id])

    authorize @post

    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post

    @post.destroy

    redirect_to posts_path, status: :see_other, notice: "Post was successfully deleted."
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
