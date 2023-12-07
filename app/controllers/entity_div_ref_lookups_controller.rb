class EntityDivRefLookupsController < ApplicationController
  before_action :set_entity_div_ref_lookup, only: %i[ show edit update destroy ]

  # GET /entity_div_ref_lookups or /entity_div_ref_lookups.json
  def index

    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @entity_div_ref_lookups = EntityDivRefLookup.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')


  end

  def entity_div_ref_lookup_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @entity_div_ref_lookups = EntityDivRefLookup.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  # GET /entity_div_ref_lookups/1 or /entity_div_ref_lookups/1.json
  def show
  end

  # GET /entity_div_ref_lookups/new
  def new
    @entity_div_ref_lookup = EntityDivRefLookup.new
  end

  # GET /entity_div_ref_lookups/1/edit
  def edit
  end

  # POST /entity_div_ref_lookups or /entity_div_ref_lookups.json
  def create
    @entity_div_ref_lookup = EntityDivRefLookup.new(entity_div_ref_lookup_params)

    respond_to do |format|
      if @entity_div_ref_lookup.save
        format.html { redirect_to entity_div_ref_lookup_url(@entity_div_ref_lookup), notice: "Entity div ref lookup was successfully created." }
        format.json { render :show, status: :created, location: @entity_div_ref_lookup }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entity_div_ref_lookup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_div_ref_lookups/1 or /entity_div_ref_lookups/1.json
  def update
    respond_to do |format|
      if @entity_div_ref_lookup.update(entity_div_ref_lookup_params)
        format.html { redirect_to entity_div_ref_lookup_url(@entity_div_ref_lookup), notice: "Entity div ref lookup was successfully updated." }
        format.json { render :show, status: :ok, location: @entity_div_ref_lookup }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entity_div_ref_lookup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_div_ref_lookups/1 or /entity_div_ref_lookups/1.json
  def destroy
    @entity_div_ref_lookup.destroy!

    respond_to do |format|
      format.html { redirect_to entity_div_ref_lookups_url, notice: "Entity div ref lookup was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_div_ref_lookup
      @entity_div_ref_lookup = EntityDivRefLookup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entity_div_ref_lookup_params
      params.require(:entity_div_ref_lookup).permit(:entity_div_code, :pan, :name, :active_status, :del_status, :user_id)
    end
end
