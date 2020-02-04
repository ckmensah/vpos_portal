class EntityInfoExtrasController < ApplicationController
  before_action :set_entity_info_extra, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :load_permissions
  # GET /entity_info_extras
  # GET /entity_info_extras.json
  def index
    @entity_info_extras = EntityInfoExtra.all
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @entity_info_extras = EntityInfoExtra.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  def entity_info_extra
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @entity_info_extras = EntityInfoExtra.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  # GET /entity_info_extras/1
  # GET /entity_info_extras/1.json
  def show
  end

  # GET /entity_info_extras/new
  def new
    @entity_info_extra = EntityInfoExtra.new
  end

  # GET /entity_info_extras/1/edit
  def edit
  end

  # POST /entity_info_extras
  # POST /entity_info_extras.json
  def create
    @entity_info_extra = EntityInfoExtra.new(entity_info_extra_params)
    respond_to do |format|
      if @entity_info_extra.save
        format.html { redirect_to @entity_info_extra, notice: 'Entity extra info was successfully created.' }
        flash.now[:danger] = "Entity extra info was successfully created."
        format.js { render :show}
        format.json { render :show, status: :created, location: @entity_info_extra }
      else
        format.html { render :new }
        format.js {render :new }
        format.json { render json: @entity_info_extra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_info_extras/1
  # PATCH/PUT /entity_info_extras/1.json
  def update

    respond_to do |format|
      if @entity_info_extra.update(entity_info_extra_params)
        format.html { redirect_to @entity_info_extra, notice: 'Entity info extra was successfully updated.' }
        flash.now[:danger] = "Entity info extra was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_info_extra }
      else
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @entity_info_extra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_info_extras/1
  # DELETE /entity_info_extras/1.json
  def destroy
    @entity_info_extra.destroy
    respond_to do |format|
      format.html { redirect_to entity_info_extras_url, notice: 'Entity info extra was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_info_extra
      @entity_info_extra = EntityInfoExtra.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_info_extra_params
      params.require(:entity_info_extra).permit(:entity_code, :contact_number, :web_url, :contact_email, :location_address, :postal_address, :comment, :active_status, :del_status, :user_id)
    end
end
