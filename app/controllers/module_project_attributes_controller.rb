class ModuleProjectAttributesController < ApplicationController

  def edit
    set_page_title "Edit Module Project Attribute"
    @mpa = ModuleProjectAttribute.find(params[:id])
  end

  def update
    @mpa = Language.find(params[:id])

    respond_to do |format|
      if @mpa.update_attributes(params[:module_project_attribute])
        format.html { redirect_to @mpa, notice: 'MPA was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @mpa.errors, status: :unprocessable_entity }
      end
    end
  end
end
