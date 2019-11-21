class CityTownMastersController < ApplicationController
  before_action :set_city_town_master, only: [:show, :edit, :update, :destroy]

  # GET /city_town_masters
  # GET /city_town_masters.json
  def index
    # @city_town_masters = CityTownMaster.all
  end

  def city_town_master_index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @city_town_masters = CityTownMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  # GET /city_town_masters/1
  # GET /city_town_masters/1.json
  def show
  end

  # GET /city_town_masters/new
  def new
    @city_town_master = CityTownMaster.new
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
  end

  # GET /city_town_masters/1/edit
  def edit
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
  end

  # POST /city_town_masters
  # POST /city_town_masters.json
  def create
    @city_town_master = CityTownMaster.new(city_town_master_params)
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    respond_to do |format|
      if @city_town_master.save
        format.html { redirect_to @city_town_master, notice: 'City town master was successfully created.' }
        flash.now[:danger] = "City/Town was successfully created."
        format.js { render :show}
        format.json { render :show, status: :created, location: @city_town_master }
      else
        format.html { render :new }
        format.js {render :new }
        format.json { render json: @city_town_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /city_town_masters/1
  # PATCH/PUT /city_town_masters/1.json
  def update
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)

    respond_to do |format|
      if @city_town_master.update(city_town_master_params)
        format.html { redirect_to @city_town_master, notice: 'City town master was successfully updated.' }
        flash.now[:danger] = "City/Town was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @city_town_master }
      else
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @city_town_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /city_town_masters/1
  # DELETE /city_town_masters/1.json
  def destroy
    if @city_town_master.active_status
      @city_town_master.active_status = false
      @city_town_master.save(validate: false)
      @city_town_masters = CityTownMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to allergy_masters_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'City/Town was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @city_town_master.active_status = true
      @city_town_master.save(validate: false)
      @city_town_masters = CityTownMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to allergy_masters_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'City/Town was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city_town_master
      @city_town_master = CityTownMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_town_master_params
      params.require(:city_town_master).permit(:city_town_name, :region_id, :comment, :active_status, :del_status, :user_id)
    end
end
