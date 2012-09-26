class ActivityCategoriesController < ApplicationController
  def index
    authorize! :manage_activity_categories, ActivityCategory
    @activity_categories = ActivityCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_categories }
    end
  end

  def show
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_category }
    end
  end

  def new
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @activity_category }
    end
  end

  def edit
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.find(params[:id])
  end

  def create
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.new(params[:activity_category])

    respond_to do |format|
      if @activity_category.save
        format.html { redirect_to @activity_category, notice: 'Activity category was successfully created.' }
        format.json { render json: @activity_category, status: :created, location: @activity_category }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.find(params[:id])

    respond_to do |format|
      if @activity_category.update_attributes(params[:activity_category])
        format.html { redirect_to @activity_category, notice: 'Activity category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :manage_activity_categories, ActivityCategory
    @activity_category = ActivityCategory.find(params[:id])
    @activity_category.destroy

    respond_to do |format|
      format.html { redirect_to activity_categories_url }
      format.json { head :ok }
    end
  end
end
