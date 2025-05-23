class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize User

    @users = User.where.not(id: current_user.id)
  end

  def show
    authorize User

    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def upload_avatar
    @user = User.find(params[:id])

    authorize @user

    if params[:user][:avatar].present?
      if @user.update(avatar: params[:user][:avatar])
        redirect_to @user, notice: "Profile picture was successfully updated."
      else
        redirect_to @user, alert: "Failed to update profile picture: #{@user.errors.full_messages.join(', ')}"
      end
    else
      redirect_to @user, alert: "No file was selected."
    end
  end
end
