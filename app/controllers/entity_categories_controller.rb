class EntityCategoriesController < ApplicationController
  before_action :set_entity_category, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /entity_categories
  # GET /entity_categories.json
  def index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @entity_categories = EntityCategory.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end


  def entity_category_index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @entity_categories = EntityCategory.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end


  # GET /entity_categories/1
  # GET /entity_categories/1.json
  def show
  end

  # GET /entity_categories/new
  def new
    @entity_category = EntityCategory.new
  end

  # GET /entity_categories/1/edit
  def edit
  end

  # POST /entity_categories
  # POST /entity_categories.json

  def create
    @entity_category = EntityCategory.new(activity_type_params)
    respond_to do |format|
      if @entity_category.save
        format.html { redirect_to @entity_category, notice: 'Entity category was successfully created.' }
        flash.now[:danger] = "Entity category was successfully created."
        format.js { render :show}
        format.json { render :show, status: :created, location: @entity_category }
      else
        format.html { render :new }
        format.js {render :new }
        format.json { render json: @entity_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_categories/1
  # PATCH/PUT /entity_categories/1.json

  def update

    respond_to do |format|
      if @entity_category.update(entity_category_params)
        format.html { redirect_to @entity_category, notice: 'Entity category was successfully updated.' }
        flash.now[:danger] = "Entity category was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_category }
      else
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @entity_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_categories/1
  # DELETE /entity_categories/1.json

  def destroy
    if @entity_category.active_status
      @entity_category.active_status = false
      @entity_category.save(validate: false)
      @entity_categories = EntityCategory.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_categories_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Entity category was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @entity_category.active_status = true
      @entity_category.save(validate: false)
      @entity_categories = EntityCategory.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_categories_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Entity category was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_category
      @entity_category = EntityCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_category_params
      params.require(:entity_category).permit(:assigned_code, :category_name, :comment, :active_status, :del_status, :user_id)
    end
end
