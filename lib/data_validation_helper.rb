
#Module for master data method
module DataValidationHelper

  #Validate changes on record
  def validate_change
    #get the record controller name
    controller = params[:controller]    #controller.controller_name
    record_class_name = controller.classify  #controller.singularize.capitalize
    #TODO: Define authorization for master data validation
    #authorize! :"edit_#{record_class_name.downcase.pluralize}", "#{record_class_name.constantize}"

    begin
      #Get the record to validate from its ID
      @record = record_class_name.constantize.find(params[:id])
      trans_successful = false
      #Temporally save uuid
      temp_current_uuid = @record.uuid
      parent_record = @record.parent_reference

      #If record parent is nil (for new created record)...only status is going to change
      if parent_record.nil?
        @record.record_status = @defined_status
        if @record.save
          flash[:notice] = 'Changes on record was successfully validated.'
        else
          flash[:error] =  'Changes validation failed with no parent.'
        end
      else
        temp_parent_uuid = parent_record.uuid
        #Create transaction to avoid uuid duplication error in DB
        parent_record.transaction do
          @record.uuid = UUIDTools::UUID.timestamp_create.to_s
          parent_record.record_status = @retired_status
          parent_record.uuid = temp_current_uuid
          parent_record.reference_uuid = @record.reference_uuid
          @record.save!
          parent_record.save!
          trans_successful = true
        end

        if trans_successful
          @record.reference_uuid = nil
          @record.uuid = temp_parent_uuid
          @record.record_status = @defined_status

          if @record.save
            flash[:notice] = 'Changes on record was successfully validated.'
          else
           flash[:error] =  'Changes validation failed.'
          end
        end
      end

      redirect_to :back and return

    rescue ActiveRecord::StatementInvalid => error
      put "#{error.message}"
      flash[:error] = "#{error.message}"
      redirect_to :back and return
    rescue ActiveRecord::RecordInvalid => err   #ActiveRecord::RecordInvalid
      flash[:error] = "#{err.message}"
      redirect_to :back
    end
  end


  #Restoring change on record
  def restore_change
    #get the record controller name
    controller = params[:controller]    #controller.controller_name
    record_class_name = controller.classify  #controller.singularize.capitalize
    begin
      #Get the record to validate from its ID
      @record = record_class_name.constantize.find(params[:id])
      trans_successful = false
      if @record.is_retired?
        #Temporally save uuid
        temp_current_uuid = @record.uuid
        child_record =  record_class_name.constantize.find_by_uuid(@record.reference_uuid) #@record.child

        if child_record.nil?
          @record.record_status = @defined_status
          if @record.save
            flash[:notice] = 'Change on record was successfully restored.'
          else
            flash[:error] =  'Changes restoration failed.'
          end

        else
          temp_child_uuid = child_record.uuid

          #Create transaction to avoid uuid duplication error in DB
          child_record.transaction do
            @record.uuid = UUIDTools::UUID.timestamp_create.to_s
            child_record.record_status = @retired_status
            child_record.uuid = temp_current_uuid
            child_record.reference_uuid = @record.reference_uuid
            @record.save!(:validate => false)
            child_record.save!(:validate => false)
            trans_successful = true
          end

          if trans_successful
            @record.reference_uuid = nil
            @record.uuid = temp_child_uuid
            @record.record_status = @defined_status

            if @record.save
              flash[:notice] = 'Change on record was successfully restored.'
            else
              flash[:error] =  'Changes restoration failed.'
            end
          end
        end
      else
        flash[:error] = "unauthorized action: you are trying to restore a non retired record ! "
      end

      redirect_to :back and return

    rescue ActiveRecord::StatementInvalid => error
      put "#{error.message}"
      flash[:error] = "#{error.message}"
      redirect_to :back and return
    rescue ActiveRecord::RecordInvalid => err
      flash[:error] = "#{err.message}"
      redirect_to :back
    end
  end

end