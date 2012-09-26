class ProjectCategoriesController < ApplicationController
  # GET /project_categories
  # GET /project_categories.json
  def index
    @project_categories = ProjectCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_categories }
    end
  end

  # GET /project_categories/1
  # GET /project_categories/1.json
  def show
    @project_category = ProjectCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_category }
    end
  end

  # GET /project_categories/new
  # GET /project_categories/new.json
  def new
    @project_category = ProjectCategory.new

    respond_to do |format|
      format.html # _new.html.erb
      format.json { render json: @project_category }
    end
  end

  # GET /project_categories/1/edit
  def edit
    @project_category = ProjectCategory.find(params[:id])
  end

  # POST /project_categories
  # POST /project_categories.json
  def create
    @project_category = ProjectCategory.new(params[:project_category])

    respond_to do |format|
      if @project_category.save
        format.html { redirect_to "/projects_global_params", notice: 'Project category was successfully created.' }
        format.json { render json: @project_category, status: :created, location: @project_category }
      else
        format.html { render action: "new" }
        format.json { render json: @project_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_categories/1
  # PUT /project_categories/1.json
  def update
    @project_category = ProjectCategory.find(params[:id])

    respond_to do |format|
      if @project_category.update_attributes(params[:project_category])
        format.html { redirect_to @project_category, notice: 'Project category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_categories/1
  # DELETE /project_categories/1.json
  def destroy
    @project_category = ProjectCategory.find(params[:id])
    @project_category.destroy

    respond_to do |format|
      format.html { redirect_to project_categories_url }
      format.json { head :ok }
    end
  end
end
