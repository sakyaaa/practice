# frozen_string_literal: true

# likes controller
class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize Like

    current_user.likes.create(likable: find_likable) unless current_user.likes.exists?(likable: find_likable)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def destroy
    @like = current_user.likes.find_by(likable: find_likable)

    authorize @like

    @like.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  private

  def find_likable
    { comment_id: Comment, post_id: Post }.each do |param_key, model_class|
      next unless params[param_key]

      return model_class.find(params[param_key])
    end
  end
end
