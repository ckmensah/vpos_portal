class ActivityCategoryDivsController < ApplicationController
  before_action :set_activity_category_div, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /activity_category_divs
  # GET /activity_category_divs.json
  def index
    @activity_category_divs = ActivityCategoryDiv.all
  end

  # GET /activity_category_divs/1
  # GET /activity_category_divs/1.json
  def show
  end

  # GET /activity_category_divs/new
  def new
    @activity_category_div = ActivityCategoryDiv.new
    @activity_categories = ActivityCategory.where(active_status: true).order(activity_cat_desc: :asc)
  end

  # GET /activity_category_divs/1/edit
  def edit
    @activity_categories = ActivityCategory.where(active_status: true).order(activity_cat_desc: :asc)
  end

  # POST /activity_category_divs
  # POST /activity_category_divs.json
  def create
    @activity_category_div = ActivityCategoryDiv.new(activity_category_div_params)
    @activity_categories = ActivityCategory.where(active_status: true).order(activity_cat_desc: :asc)

    respond_to do |format|
      if @activity_category_div.save
        flash.now[:notice] = "Activity category div was successfully created."
        format.js { render :show }
        format.html { redirect_to @activity_category_div, notice: 'Activity category div was successfully created.' }
        format.json { render :show, status: :created, location: @activity_category_div }
      else
        format.js { render :new }
        format.html { render :new }
        format.json { render json: @activity_category_div.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_category_divs/1
  # PATCH/PUT /activity_category_divs/1.json
  def update
    respond_to do |format|
      @activity_categories = ActivityCategory.where(active_status: true).order(activity_cat_desc: :asc)
      if @activity_category_div.update(activity_category_div_params)
        flash.now[:notice] = "Category Type was successfully updated."
        format.js { render :show }
        format.html { redirect_to @activity_category_div, notice: 'Activity category div was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_category_div }
      else
        format.js { render :edit }
        format.html { render :edit }
        format.json { render json: @activity_category_div.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_category_divs/1
  # DELETE /activity_category_divs/1.json

  def destroy
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    if @activity_category_div.active_status
      @activity_category_div.active_status = false
      @activity_category_div.save(validate: false)
      @activity_category_divs = ActivityCategoryDiv.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Activity type was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @activity_category_div.active_status = true
      @activity_category_div.save(validate: false)
      @activity_category_divs = ActivityCategoryDiv.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Activity type was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_category_div
      @activity_category_div = ActivityCategoryDiv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_category_div_params
      params.require(:activity_category_div).permit(:division_code, :activity_category_id, :activity_div_cat_id, :category_div_desc, :comment, :active_status, :del_status, :user_id)
    end
end
