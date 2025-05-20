class UsersController < ApplicationController
  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        redirect_to root_path, notice: "User was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to root_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [ :username, :email, :password ])
    end
end
