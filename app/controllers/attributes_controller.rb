class AttributesController < ApplicationController

  def index
    authorize! :manage_attributes, Attribute
    set_page_title "Attributes"
    @attributes = Attribute.all
  end

  def new
    authorize! :manage_attributes, Attribute
    set_page_title "Attributes"
    @attribute = Attribute.new
  end

  def edit
    authorize! :manage_attributes, Attribute
    set_page_title "Attributes"
    @attribute = Attribute.find(params[:id])
  end

  def create
    authorize! :manage_attributes, Attribute
    @attribute = Attribute.new(params[:attribute])
      if @attribute.save
        redirect_to attributes_url
      else
         render action: "new"
      end
    end
  end

  def update
    authorize! :manage_attributes, Attribute
    @attribute = Attribute.find(params[:id])
    respond_to do |format|
      if @attribute.update_attributes(params[:attribute])
        @attribute.update_attribute("options", params[:options])

        @attribute.attr_type = params[:options][0]
        @attribute.save

        redirect_to attributes_url
      else
        render action: "edit"
      end
    end
  end

  def destroy
    authorize! :manage_attributes, Attribute
    @attribute = Attribute.find(params[:id])
    @attribute.destroy

    redirect_to attributes_url
end
