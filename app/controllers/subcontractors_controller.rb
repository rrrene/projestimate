class SubcontractorsController < ApplicationController

  def new
    @subcontractor = Subcontractor.new
  end

  def edit
    @subcontractor = Subcontractor.find(params[:id])
  end

  def create
    @subcontractor = Subcontractor.new(params[:subcontractor])

    if @subcontractor.save
      flash[:notice] = I18n.t(:notice_successfully_created, :value => "Subcontractor")
      redirect_to edit_organization_path(@subcontractor.organization_id, :anchor => "tabs-5")
    else
      render action: "new"
    end
  end

  def update
    @subcontractor = Subcontractor.find(params[:id])

    if @subcontractor.update_attributes(params[:subcontractor])
      flash[:notice] = I18n.t(:notice_successfully_updated, :value => "Subcontractor")
      redirect_to (edit_organization_path(@subcontractor.organization_id, :anchor => "tabs-5"))
    else
      render action: "edit"
    end
  end

  def destroy
    @subcontractor = Subcontractor.find(params[:id])
    organization_id = @subcontractor.organization_id
    @subcontractor.destroy
    flash[:notice] = I18n.t(:notice_successfully_deleted, :value => "Subcontractor")
    redirect_to edit_organization_path(organization_id, :anchor => "tabs-5")
  end
end
