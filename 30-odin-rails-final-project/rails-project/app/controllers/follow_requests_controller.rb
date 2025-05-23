class FollowRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    @follow_request = current_user.follow_requests_as_follower.build(follow_request_params)

    if @follow_request.save
      FollowRequestsChannel.broadcast_to(
        @follow_request.source,
        {
          type: "follow_request",
          message: "#{current_user.name} wants to follow you",
          follow_request_id: @follow_request.id
        }
      )
      render json: { message: "Follow request sent successfully" }, status: :created
    else
      render json: { errors: @follow_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def accept
    @follow_request = current_user.follow_requests_as_source.find(params[:id])

    if @follow_request.update(status: "accepted")
      FollowRequestsChannel.broadcast_to(
        @follow_request.follower,
        {
          type: "follow_request_accepted",
          message: "#{@follow_request.source.name} accepted your follow request"
        }
      )
      render json: { message: "Follow request accepted" }
    else
      render json: { errors: @follow_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def reject
    @follow_request = current_user.follow_requests_as_source.find(params[:id])

    if @follow_request.update(status: "rejected")
      FollowRequestsChannel.broadcast_to(
        @follow_request.follower,
        {
          type: "follow_request_rejected",
          message: "#{@follow_request.source.name} rejected your follow request"
        }
      )
      render json: { message: "Follow request rejected" }
    else
      render json: { errors: @follow_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def pending
    @pending_requests = current_user.follow_requests_as_source.where(status: "pending")
  end

  private

  def follow_request_params
    params.require(:follow_request).permit(:source_id)
  end
end
