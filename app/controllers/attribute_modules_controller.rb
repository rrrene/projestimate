class AttributeModulesController < ApplicationController

  def create
    @attribute_module = AttributeModule.new(params[:attribute_module])

    respond_to do |format|
      if @attribute_module.save
        format.html { redirect_to @attribute_module, notice: 'Attribute module was successfully created.' }
        format.json { render json: @attribute_module, status: :created, location: @attribute_module }
      else
        format.html { render action: "new" }
        format.json { render json: @attribute_module.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @attribute_module = AttributeModule.find(params[:id])
    @attribute_module.destroy

    respond_to do |format|
      format.html { redirect_to attribute_modules_url }
      format.json { head :ok }
    end
  end

end
