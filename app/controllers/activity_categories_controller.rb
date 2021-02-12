class ActivityCategoriesController < ApplicationController
  before_action :set_activity_category, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /activity_categories
  # GET /activity_categories.json
  def index

    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @activity_categories = ActivityCategory.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end


  def activity_category_index

    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @activity_categories = ActivityCategory.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  # GET /activity_categories/1
  # GET /activity_categories/1.json
  def show
  end

  # GET /activity_categories/new
  def new
    @activity_category = ActivityCategory.new
  end

  # GET /activity_categories/1/edit
  def edit
  end

  # POST /activity_categories
  # POST /activity_categories.json
  def create
    @activity_category = ActivityCategory.new(activity_category_params)

    respond_to do |format|
      if @activity_category.save
        flash.now[:notice] = "Activity Category was successfully created."
        format.js { render :show}
        format.html { redirect_to @activity_category, notice: 'Activity category was successfully created.' }
        format.json { render :show, status: :created, location: @activity_category }
      else

        format.js { render :new }
        format.html { render :new }
        format.json { render json: @activity_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_categories/1
  # PATCH/PUT /activity_categories/1.json
  def update
    respond_to do |format|
      if @activity_category.update(activity_category_params)
        flash.now[:danger] = "Activity category was successfully updated."
        format.js { render :show}
        format.html { redirect_to @activity_category, notice: 'Activity category was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_category }
      else
        format.js { render :edit}
        format.html { render :edit }
        format.json { render json: @activity_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_categories/1
  # DELETE /activity_categories/1.json
  def destroy
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    if @activity_category.active_status
      @activity_category.active_status = false
      @activity_category.save(validate: false)
      @activity_categories = ActivityCategory.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Activity Category was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @activity_category.active_status = true
      @activity_category.save(validate: false)
      @activity_categories = ActivityCategory.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Activity Category was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_category
      @activity_category = ActivityCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_category_params
      params.require(:activity_category).permit(:assigned_code, :activity_cat_desc, :image, :image_path, :comment, :active_status, :del_status, :user_id)
    end
end
