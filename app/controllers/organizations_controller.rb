class OrganizationsController < ApplicationController
  before_action :logged_in_user, only: %i[show new create edit update]
  before_action :set_organization, only: %i[show edit update]
  before_action :verify_access, only: %i[ edit update]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  
  
  def index
  end

  def show
    if current_user.id == @organization.user_id
      @org_shifts = Shift.where(organization_id: @organization.id).order("updated_at DESC")
    else 
      @organization_bio = Organization.where(id: params[:id]).select(:org_name, :org_address, :org_description, :org_city, :org_state).first
    end
  end

  def new
    @is_org_user = User.where(id: current_user.id, user_type: "organization").first
    @has_org = Organization.where(user_id: current_user.id).first

    if @is_org_user && @has_org.blank?
        @organization = Organization.new
    elsif @is_org_user && @has_org
        flash[:danger] = "You have already created your organization."
        redirect_to user_path(current_user.id)
    else
        flash[:danger] = "You do not have authority to access that."
        redirect_to user_path(current_user.id)
    end
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
  end

  def update
    if @organization.update(organization_params)
      flash[:success] = "Organization updated successfully!"
      redirect_to user_path(current_user.id)
    else
      flash[:danger] = "Something went wrong."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @organization
  end

  # only the organization logged in has access to the organization actions
  def verify_access
    unless current_user.id == @organization.user_id
      flash[:warning] = "You do not have authority to access that."
      redirect_to user_path(current_user.id)
    end
  end

  def organization_params
    params.require(:organization).permit(:org_name, :org_description, :org_address, :org_city, :org_state, :user_id)
  end
end
