class OrganizationsController < ApplicationController
  before_action :logged_in_user, only: %i[show new create edit update]
  before_action :set_organization, only: %i[show edit update]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  attr_accessor :form_labels, :form_text_fields, :form_submit_button
  
  
  def index
  end

  def show
    @org_shifts = Shift.where(organization_id: @organization.id).order("updated_at DESC")
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
    @form_label = "col-12 col-md-4 col-lg-2"
    @form_text_fields = "col-12 col-md-8 col-lg-10 mx-auto"
    @form_submit_button = "col-6 col-lg-4 mx-auto"
  end

  def update
    if @organization.update(organization_params)
      flash[:success] = "Organization updated successfully!"
      redirect_to user_path
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

  def organization_params
    params.require(:organization).permit(:org_name, :org_description, :org_address, :org_city, :org_state, :user_id)
  end
end
