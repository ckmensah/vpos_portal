class RegionMastersController < ApplicationController
  before_action :set_region_master, only: [:show, :edit, :update, :destroy]

  # GET /region_masters
  # GET /region_masters.json
  def index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @region_masters = RegionMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order(region_name: :asc)
    @city_town_masters = CityTownMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order(city_town_name: :asc)
    @suburb_masters = SuburbMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order(suburb_name: :asc)

  end

  def region_master_index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @region_masters = RegionMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order(region_name: :asc)

  end

  # GET /region_masters/1
  # GET /region_masters/1.json
  def show
  end

  # GET /region_masters/new
  def new
    @region_master = RegionMaster.new
  end

  # GET /region_masters/1/edit
  def edit
  end

  # POST /region_masters
  # POST /region_masters.json
  def create
    @region_master = RegionMaster.new(region_master_params)

    respond_to do |format|
      if @region_master.save
        format.html { redirect_to @region_master, notice: 'Region master was successfully created.' }
        flash.now[:danger] = "Region master was successfully created."
        format.js { render :show}
        format.json { render :show, status: :created, location: @region_master }
      else
        format.html { render :new }
        format.js {render :new }
        format.json { render json: @region_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /region_masters/1
  # PATCH/PUT /region_masters/1.json
  def update
    respond_to do |format|
      if @region_master.update(region_master_params)
        format.html { redirect_to @region_master, notice: 'Region master was successfully updated.' }
        flash.now[:danger] = "Region master was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @region_master }
      else
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @region_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /region_masters/1
  # DELETE /region_masters/1.json

  def destroy
    if @region_master.active_status
      @region_master.active_status = false
      @region_master.save(validate: false)
      @region_masters = RegionMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to allergy_masters_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Region was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @region_master.active_status = true
      @region_master.save(validate: false)
      @region_masters = RegionMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to allergy_masters_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Region was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_region_master
      @region_master = RegionMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def region_master_params
      params.require(:region_master).permit(:region_name, :comment, :active_status, :del_status, :user_id)
    end
end
