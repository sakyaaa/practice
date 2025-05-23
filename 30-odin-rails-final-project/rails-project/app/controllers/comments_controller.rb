class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize Comment

    @post = Post.find(params[:post_id])
    @comments = @post.comments
  end

  def create
    authorize Comment

    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: "Comment was successfully created."
    else
      redirect_to @post, alert: @comment.errors.full_messages.join(", ")
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    authorize @comment

    @comment.destroy

    redirect_to @post, status: :see_other, notice: "Comment was successfully deleted."
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
