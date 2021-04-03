class OrganizationsController < ApplicationController
  before_action :logged_in_user, only: []
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  
  def index
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params.merge(user_id: current_user.id))
    if @organization.save
      flash[:success] = "Organization created successfully!"
      redirect_to user_path(current_user.id)
    else
      flash[:error] = "Something went wrong."
      render 'new'
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update(organization_params)
      flash[:success] = "Organization updated successfully!"
      redirect_to @organization
    else
      flash[:danger] = "Something went wrong."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:org_name, :org_description, :org_address, :org_city, :org_state, :user_id)
  end
end
