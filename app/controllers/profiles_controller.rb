class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update destroy]

  # GET /profiles
  def index
    @profiles = Profile.kept.order(created_at: :desc)  # Excluding soft-deleted profiles
  end

  # GET /profiles/:id
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params)

    if @profile.save
      redirect_to @profile, notice: "Profile successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /profiles/:id/edit
  def edit
  end

  # PATCH/PUT /profiles/:id
  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: "Profile successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/:id
  def destroy
    @profile.discard  # Soft delete
    redirect_to profiles_path, notice: "Profile has been deleted."
  end

  private

  def set_profile
    @profile = Profile.kept.find(params[:id])  # Ensure not fetching soft-deleted records
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :date_of_birth, :email, :phone_number, :address, :branch_id, :profile_image, :account_type, :users_id)
  end
end
