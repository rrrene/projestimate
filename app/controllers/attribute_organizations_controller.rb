class AttributeOrganizationsController < ApplicationController

  def update_selected_attribute_organizations
    authorize! :manage_organizations, Organization
    @organization = Organization.find(params[:organization_id])

    attributes_ids = params[:organization][:pe_attribute_ids]

    @organization.attribute_organizations.each do |m|
      m.destroy unless attributes_ids.include?(m.pe_attribute_id.to_s)
      attributes_ids.delete(m.pe_attribute_id.to_s)
    end

    attributes_ids.each do |g|
      @organization.attribute_organizations.create(:pe_attribute_id => g.to_i) unless g.blank?
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
      attribute.update_attribute('is_mandatory', params[:is_mandatory][i])
    end
    redirect_to redirect("/organizationals_params"), :notice => "#{I18n.t (:notice_attribute_organization_successful_updated)}"
  end

end
