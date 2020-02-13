class ActivityDivCatsController < ApplicationController
  before_action :set_activity_div_cat, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions

  # GET /activity_div_cats
  # GET /activity_div_cats.json
  def index
    #@activity_div_cats = ActivityDivCat.all
  end

  def activity_div_cat_index

    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @activity_div_cats = ActivityDivCat.where(del_status: false, division_code: params[:code]).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  # GET /activity_div_cats/1
  # GET /activity_div_cats/1.json
  def show

    @activity_category_divs = ActivityCategoryDiv.where(active_status: true, division_code: params[:code], activity_div_cat_id: @activity_div_cat.id).order(created_at: :desc)
  end

  # GET /activity_div_cats/new
  def new
    @activity_div_cat = ActivityDivCat.new
  end

  # GET /activity_div_cats/1/edit
  def edit
  end

  # POST /activity_div_cats
  # POST /activity_div_cats.json
  def create
    @activity_div_cat = ActivityDivCat.new(activity_div_cat_params)

    respond_to do |format|
      if @activity_div_cat.save
        flash.now[:notice] = "Activity Sub Category was successfully created."
        format.js { render :show }
        format.html { redirect_to @activity_div_cat, notice: 'Activity div cat was successfully created.' }
        format.json { render :show, status: :created, location: @activity_div_cat }
      else
        format.js { render :new}
        format.html { render :new }
        format.json { render json: @activity_div_cat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_div_cats/1
  # PATCH/PUT /activity_div_cats/1.json
  def update
    respond_to do |format|
      if @activity_div_cat.update(activity_div_cat_params)
        flash.now[:notice] = "Activity Sub Category was successfully updated."
        format.js { render :show}
        format.html { redirect_to @activity_div_cat, notice: 'Activity div cat was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_div_cat }
      else
        format.js { render :edit}
        format.html { render :edit }
        format.json { render json: @activity_div_cat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_div_cats/1
  # DELETE /activity_div_cats/1.json
  def destroy
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    if @activity_div_cat.active_status
      @activity_div_cat.active_status = false
      @activity_div_cat.save(validate: false)
      @activity_div_cats = ActivityDivCat.where(del_status: false, division_code: params[:code]).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Activity Sub Category was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @activity_div_cat.active_status = true
      @activity_div_cat.save(validate: false)
      @activity_div_cats = ActivityDivCat.where(del_status: false, division_code: params[:code]).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Activity Sub Category was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_div_cat
      @activity_div_cat = ActivityDivCat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_div_cat_params
      params.require(:activity_div_cat).permit(:division_code, :div_cat_desc, :comment, :active_status, :del_status, :user_id)
    end

end


