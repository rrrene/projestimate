class AttributeOrganizationsController < ApplicationController

  def update_selected_attribute_organizations
    authorize! :manage_organizations, Organization
    @organization = Organization.find(params[:organization_id])
    #Get the Capitalization module
    @capitalization_module = Pemodule.find_by_alias("capitalize")

    attributes_ids = params[:organization][:pe_attribute_ids]
    puts "Attribute_ids_1 = #{attributes_ids}"

    @organization.attribute_organizations.each do |m|
      m.destroy unless attributes_ids.include?(m.pe_attribute_id.to_s)
      attributes_ids.delete(m.pe_attribute_id.to_s)
    end

    puts "Attribute_ids_2 = #{attributes_ids}"

    attributes_ids.each do |g|
      @organization.attribute_organizations.create(:pe_attribute_id => g.to_i) unless g.blank?
    end
    @organization.pe_attributes(force_reload = true)

    puts "Attribute_ids_3 = #{attributes_ids}"

    if @organization.save
      unless @capitalization_module.nil?
        organization_attributes = @organization.pe_attribute_ids
        #puts "Organization_attributes = #{organization_attributes}"

        capitalization_attributes = @capitalization_module.pe_attribute_ids
        #puts "Capitalization_attributes = #{capitalization_attributes}"

        non_selected_attribute_ids =  capitalization_attributes - organization_attributes
        #puts "Non_selected_attribute_ids = #{non_selected_attribute_ids}"

        unless non_selected_attribute_ids.empty?
          non_selected_attribute_ids.each do |id_to_delete|
            cap_attr_modules = AttributeModule.where(["pemodule_id = ? AND pe_attribute_id = ?", @capitalization_module.id, id_to_delete]).first
            puts "cap_attr_modules = #{cap_attr_modules}"
            AttributeModule.delete(cap_attr_modules)
          end
        end

        attributes_ids.reject(&:empty?).each do |new_attr_id|
          organization_attr = @organization.attribute_organizations.where("pe_attribute_id = ?", new_attr_id).first
          attr_module = @capitalization_module.attribute_modules.create(:pe_attribute_id => new_attr_id, :is_mandatory => organization_attr.is_mandatory, :in_out => "both")
          attr_module.save
        end
      end

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
