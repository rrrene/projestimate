class AttributeOrganizationsController < ApplicationController

  def update_selected_attribute_organizations
    authorize! :manage_organizations, Organization
    @organization = Organization.find(params[:organization_id])

    # Get the Capitalization module. It is set in the ApplicationController : @capitalization_module = Pemodule.find_by_alias("capitalization")

    attributes_ids = params[:organization][:pe_attribute_ids]

    @organization.attribute_organizations.each do |m|
      unless attributes_ids.include?(m.pe_attribute_id.to_s)
        m.destroy
        cap_attr_module = @capitalization_module.attribute_modules.find_by_pe_attribute_id(m.pe_attribute_id)
        @capitalization_module.attribute_modules.delete(cap_attr_module) unless cap_attr_module.nil?
      end
      attributes_ids.delete(m.pe_attribute_id.to_s)
    end

    attributes_ids.reject(&:empty?).each do |g|
      @organization.attribute_organizations.create(:pe_attribute_id => g.to_i)

      #Update de Capitalization's module_attributes
      unless @capitalization_module.nil?
        organization_attr = @organization.attribute_organizations.where("pe_attribute_id = ?", g).first
        attr_module = @capitalization_module.attribute_modules.create(:pe_attribute_id => g, :is_mandatory => organization_attr.is_mandatory, :in_out => "both")
        attr_module.save
      end
    end
    @organization.pe_attributes(force_reload = true)


    if @organization.save
      flash[:notice] = I18n.t (:notice_organization_successful_updated)
    else
      flash[:notice] = I18n.t (:error_administration_setting_failed_update)
    end

    @attribute_settings = AttributeOrganization.all(:conditions => {:organization_id => params[:organization_id]})

    redirect_to redirect("/organizationals_params"), :notice => "#{I18n.t (:notice_attribute_organization_successful_updated)}"
  end

  def update_attribute_organizations_settings
    authorize! :manage_organizations, Organization
    selected_attributes = params[:attributes]
    selected_attributes.each_with_index do |attr, i|
      attribute = AttributeOrganization.first(:conditions => {:pe_attribute_id => attr.to_i, :organization_id => params[:organization_id]})
      #Get Capitalization corresponding attribute_module
      cap_attribute_module = @capitalization_module.attribute_modules.find_by_pe_attribute_id(attr.to_i)

      attribute.update_attribute('is_mandatory', params[:is_mandatory][i])
      cap_attribute_module.update_attribute('is_mandatory', params[:is_mandatory][i])  unless cap_attribute_module.nil?
    end
    redirect_to redirect("/organizationals_params"), :notice => "#{I18n.t (:notice_attribute_organization_successful_updated)}"
  end

end
