class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ destroy ]
  before_action :authenticate_user!, only: %i[ create destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # POST /comments or /comments.json
  def create
    @post = Post.find(params.expect(:post_id))
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.post, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { redirect_to @post, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @post = Post.find(params.expect(:post_id))
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to @post, status: :see_other, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.expect(comment: [ :body, :user_id, :post_id ])
    end
end
