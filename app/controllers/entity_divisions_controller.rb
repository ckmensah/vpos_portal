class EntityDivisionsController < ApplicationController
  before_action :set_entity_division, only: [:show, :edit, :update, :destroy]

  # GET /entity_divisions
  # GET /entity_divisions.json
  def index
    @entity_divisions = EntityDivision.all
  end

  # GET /entity_divisions/1
  # GET /entity_divisions/1.json
  def show
  end

  # GET /entity_divisions/new
  def new
    @entity_division = EntityDivision.new
  end

  # GET /entity_divisions/1/edit
  def edit
  end

  # POST /entity_divisions
  # POST /entity_divisions.json
  def create
    @entity_division = EntityDivision.new(entity_division_params)

    respond_to do |format|
      if @entity_division.save
        format.html { redirect_to @entity_division, notice: 'Entity division was successfully created.' }
        format.json { render :show, status: :created, location: @entity_division }
      else
        format.html { render :new }
        format.json { render json: @entity_division.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_divisions/1
  # PATCH/PUT /entity_divisions/1.json
  def update
    respond_to do |format|
      if @entity_division.update(entity_division_params)
        format.html { redirect_to @entity_division, notice: 'Entity division was successfully updated.' }
        format.json { render :show, status: :ok, location: @entity_division }
      else
        format.html { render :edit }
        format.json { render json: @entity_division.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_divisions/1
  # DELETE /entity_divisions/1.json
  def destroy
    @entity_division.destroy
    respond_to do |format|
      format.html { redirect_to entity_divisions_url, notice: 'Entity division was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_division
      @entity_division = EntityDivision.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_division_params
      params.require(:entity_division).permit(:entity_code, :assigned_code, :division_name, :suburb_id, :activity_code, :service_label, :comment, :active_status, :del_status, :user_id)
    end
end
