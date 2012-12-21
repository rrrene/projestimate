
#Module for master data method
module DataValidationHelper

  #Validate changes on record
  def validate_change
    #get the record controller name
    controller = params[:controller]    #controller.controller_name
    record_class_name = controller.classify  #controller.singularize.capitalize
    #TODO: Define authorization for master data validation
    #authorize! :"edit_#{record_class_name.downcase.pluralize}", "#{record_class_name.constantize}"

    #Get the record to validate from its ID
    @record = record_class_name.constantize.find(params[:id])
    trans_successful = false
    #Temporally save uuid
    temp_current_uuid = @record.uuid
    parent_record = @record.parent
    temp_parent_uuid = parent_record.uuid

    begin
      #Create transaction to avoid uuid duplication error in DB
      parent_record.transaction do
        @record.uuid = nil
        parent_record.record_status = @retired_status
        parent_record.uuid = temp_current_uuid
        parent_record.ref = @record.ref
        @record.save!
        parent_record.save!
        trans_successful = true
      end

      if trans_successful
        @record.ref = nil
        @record.uuid = temp_parent_uuid
        @record.record_status = @defined_status

        if @record.save
          #redirect_to redirect(@language), notice: 'Changes on language was successfully validated.'
          flash[:notice] = 'Changes on language was successfully validated.'
        else
         flas[:error] =  'Changes validation failed.'
        end
      end

      #redirect_path = "#{record_class_name.downcase.pluralize}_path"
      #redirect_to redirect(redirect_path) and return
      redirect_to :back    # :action => "index", :controller => "#{controller}"

    rescue ActiveRecord::StatementInvalid => error
      put "#{error.message}"
      flash[:error] = "#{error.message}"
    end
  end

end