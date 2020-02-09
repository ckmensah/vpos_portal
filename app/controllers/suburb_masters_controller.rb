class SuburbMastersController < ApplicationController
  before_action :set_suburb_master, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /suburb_masters
  # GET /suburb_masters.json
  def index
    # @suburb_masters = SuburbMaster.all
  end

  def suburb_master_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @suburb_masters = SuburbMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  def city_update
    # converted_params = ActiveSupport::JSON.decode( params[:s] )
    logger.info "Params:: #{params[:id_for_region].inspect}"

    if params[:id_for_region].empty?
      @region_update_city = [["", ""]].insert(0,['Please select a city', ""])
      # @city_update_suburb = [["", ""]]
    else
      region_id_record = RegionMaster.find(params[:id_for_region])
      region_update_city = region_id_record.cities.where(active_status: true).order(city_town_name: :asc).map { |a| [a.city_town_name, a.id] }.insert(0,['Please select a city', ""])
      if region_update_city.empty?
        @region_update_city = [["", ""]].insert(0,['Please select a city', ""])
      else
        @region_update_city = region_update_city
      end
    end
    @city_update_suburb = [["", ""]].insert(0,['Please select a suburb', ""])
    logger.info "For Cities :: #{@region_update_city.inspect}"
  end

  def suburb_update
    # converted_params = ActiveSupport::JSON.decode( params[:s] )
    logger.info "Params:: #{params[:id_for_city_town].inspect}"

    if params[:id_for_city_town].empty?
      # @region_update_city = [["", ""]]
      @city_update_suburb = [["", ""]].insert(0,['Please select a suburb', ""])
    else
      city_town_id_record = CityTownMaster.find(params[:id_for_city_town])
      city_update_suburb = city_town_id_record.suburb_masters.where(active_status: true).order(suburb_name: :asc).map { |a| [a.suburb_name, a.id] }.insert(0,['Please select a suburb', ""])
      if city_update_suburb.empty?
        @city_update_suburb = [["", ""]].insert(0,['Please select a suburb', ""])
      else
        @city_update_suburb = city_update_suburb
      end
    end
    logger.info "For Suburbs :: #{@city_update_suburb.inspect}"
  end


  # GET /suburb_masters/1
  # GET /suburb_masters/1.json
  def show
  end

  # GET /suburb_masters/new
  def new
    @suburb_master = SuburbMaster.new
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    @city_town_masters = CityTownMaster.where(id: 0)
    # @city_town_masters = CityTownMaster.where(active_status: true).order(city_town_name: :asc)
  end

  # GET /suburb_masters/1/edit
  def edit
    @region_name = @suburb_master.a_city.region_id
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    @city_town_masters = CityTownMaster.where(active_status: true).order(city_town_name: :asc)
  end

  # POST /suburb_masters
  # POST /suburb_masters.json
  def create
    @suburb_master = SuburbMaster.new(suburb_master_params)
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    suburb_master_params[:region_name].present? ? @city_town_masters = CityTownMaster.where(active_status: true, region_id: suburb_master_params[:region_name]).order(city_town_name: :asc) : @city_town_masters = CityTownMaster.where(id: 0)

    #@suburb_master.city_town_id = "" if suburb_master_params[:city_town_id] == "0"
    respond_to do |format|
      if @suburb_master.save
        format.html { redirect_to @suburb_master, notice: 'Suburb master was successfully created.' }
        flash.now[:notice] = "Suburb was successfully created."
        format.js { render :show }
        format.json { render :show, status: :created, location: @suburb_master }
      else
        # @suburb_master.city_town_id = "0"
        format.html { render :new }
        format.js { render :new }
        format.json { render json: @suburb_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suburb_masters/1
  # PATCH/PUT /suburb_masters/1.json
  def update
    @region_masters = RegionMaster.where(active_status: true).order(region_name: :asc)
    @city_town_masters = CityTownMaster.where(active_status: true).order(city_town_name: :asc)
    suburb_master_params[:region_name].present? ? @city_town_masters = CityTownMaster.where(active_status: true, region_id: suburb_master_params[:region_name]).order(city_town_name: :asc) : @city_town_masters = CityTownMaster.where(id: 0)
    #suburb_master_params[:city_town_id] = "" if suburb_master_params[:city_town_id] == "0"
    logger.info "City/Town ID:: #{suburb_master_params[:city_town_id].inspect}"
    respond_to do |format|
      if @suburb_master.update(suburb_master_params)
        format.html { redirect_to @suburb_master, notice: 'Suburb master was successfully updated.' }
        flash.now[:notice] = "Suburb was successfully updated."
        format.js { render :show }
        format.json { render :show, status: :ok, location: @suburb_master }
      else
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @suburb_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suburb_masters/1
  # DELETE /suburb_masters/1.json
  def destroy
    if @suburb_master.active_status
      @suburb_master.active_status = false
      @suburb_master.save(validate: false)
      @suburb_masters = SuburbMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to allergy_masters_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Suburb was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @suburb_master.active_status = true
      @suburb_master.save(validate: false)
      @suburb_masters = SuburbMaster.all.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to allergy_masters_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Suburb was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_suburb_master
      @suburb_master = SuburbMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def suburb_master_params
      params.require(:suburb_master).permit(:suburb_name, :region_name, :city_town_id, :comment, :active_status, :del_status, :user_id)
    end
end
