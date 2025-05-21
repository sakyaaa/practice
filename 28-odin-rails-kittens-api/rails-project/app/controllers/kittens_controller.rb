class KittensController < ApplicationController
  before_action :set_kitten, only: %i[ show edit update destroy ]

  # GET /kittens or /kittens.json
  def index
    @kittens = Kitten.all
    
    respond_to do |format|
      format.html
      format.json { render json: @kittens }
    end
  end

  # GET /kittens/1 or /kittens/1.json
  def show
  end

  # GET /kittens/new
  def new
    @kitten = Kitten.new
  end

  # GET /kittens/1/edit
  def edit
  end

  # POST /kittens or /kittens.json
  def create
    @kitten = Kitten.new(kitten_params)

    respond_to do |format|
      if @kitten.save
        format.html { redirect_to @kitten, notice: "Yay! A new kitten has joined the family! 🐱" }
        format.json { render :show, status: :created, location: @kitten }
      else
        format.html { render :new, status: :unprocessable_entity, alert: "Oops! Something went wrong with your kitten creation. Please try again!" }
        format.json { render json: @kitten.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kittens/1 or /kittens/1.json
  def update
    respond_to do |format|
      if @kitten.update(kitten_params)
        format.html { redirect_to @kitten, notice: "Kitten's information has been updated successfully! 😺" }
        format.json { render :show, status: :ok, location: @kitten }
      else
        format.html { render :edit, status: :unprocessable_entity, alert: "Oh no! We couldn't update the kitten's information. Please check the form!" }
        format.json { render json: @kitten.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kittens/1 or /kittens/1.json
  def destroy
    @kitten.destroy!

    respond_to do |format|
      format.html { redirect_to kittens_path, status: :see_other, notice: "The kitten has been removed from our records. Goodbye, little one! 😿" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kitten
      @kitten = Kitten.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kitten_params
      params.require(:kitten).permit(:name, :age, :cuteness, :softness)
    end
end
