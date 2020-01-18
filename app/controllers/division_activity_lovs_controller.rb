class DivisionActivityLovsController < ApplicationController
  before_action :set_division_activity_lov, only: [:show, :edit, :update, :destroy]

  # GET /division_activity_lovs
  # GET /division_activity_lovs.json
  def index
    @division_activity_lovs = DivisionActivityLov.all
  end

  # GET /division_activity_lovs/1
  # GET /division_activity_lovs/1.json
  def show
  end

  # GET /division_activity_lovs/new
  def new
    @division_activity_lov = DivisionActivityLov.new
  end

  # GET /division_activity_lovs/1/edit
  def edit
  end

  # POST /division_activity_lovs
  # POST /division_activity_lovs.json
  def create
    @division_activity_lov = DivisionActivityLov.new(division_activity_lov_params)

    respond_to do |format|
      if @division_activity_lov.save
        format.html { redirect_to @division_activity_lov, notice: 'Division activity lov was successfully created.' }
        format.json { render :show, status: :created, location: @division_activity_lov }
      else
        format.html { render :new }
        format.json { render json: @division_activity_lov.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /division_activity_lovs/1
  # PATCH/PUT /division_activity_lovs/1.json
  def update
    respond_to do |format|
      if @division_activity_lov.update(division_activity_lov_params)
        format.html { redirect_to @division_activity_lov, notice: 'Division activity lov was successfully updated.' }
        format.json { render :show, status: :ok, location: @division_activity_lov }
      else
        format.html { render :edit }
        format.json { render json: @division_activity_lov.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /division_activity_lovs/1
  # DELETE /division_activity_lovs/1.json
  def destroy
    @division_activity_lov.destroy
    respond_to do |format|
      format.html { redirect_to division_activity_lovs_url, notice: 'Division activity lov was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_division_activity_lov
      @division_activity_lov = DivisionActivityLov.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def division_activity_lov_params
      params.require(:division_activity_lov).permit(:activity_code, :division_code, :lov_desc, :comment, :active_status, :del_status, :user_id)
    end
end
