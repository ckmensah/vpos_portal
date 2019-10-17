class EntityCategoriesController < ApplicationController
  before_action :set_entity_category, only: [:show, :edit, :update, :destroy]

  # GET /entity_categories
  # GET /entity_categories.json
  def index
    @entity_categories = EntityCategory.all
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
    @entity_category = EntityCategory.new(entity_category_params)

    respond_to do |format|
      if @entity_category.save
        format.html { redirect_to @entity_category, notice: 'Entity category was successfully created.' }
        format.json { render :show, status: :created, location: @entity_category }
      else
        format.html { render :new }
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
        format.json { render :show, status: :ok, location: @entity_category }
      else
        format.html { render :edit }
        format.json { render json: @entity_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_categories/1
  # DELETE /entity_categories/1.json
  def destroy
    @entity_category.destroy
    respond_to do |format|
      format.html { redirect_to entity_categories_url, notice: 'Entity category was successfully destroyed.' }
      format.json { head :no_content }
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
