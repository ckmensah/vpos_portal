class EntityInfosController < ApplicationController
  before_action :set_entity_info, only: [:show, :edit, :update, :destroy]

  # GET /entity_infos
  # GET /entity_infos.json
  def index
    @entity_infos = EntityInfo.all
  end

  # GET /entity_infos/1
  # GET /entity_infos/1.json
  def show
  end

  # GET /entity_infos/new
  def new
    @entity_info = EntityInfo.new
  end

  # GET /entity_infos/1/edit
  def edit
  end

  # POST /entity_infos
  # POST /entity_infos.json
  def create
    @entity_info = EntityInfo.new(entity_info_params)

    respond_to do |format|
      if @entity_info.save
        format.html { redirect_to @entity_info, notice: 'Entity info was successfully created.' }
        format.json { render :show, status: :created, location: @entity_info }
      else
        format.html { render :new }
        format.json { render json: @entity_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_infos/1
  # PATCH/PUT /entity_infos/1.json
  def update
    respond_to do |format|
      if @entity_info.update(entity_info_params)
        format.html { redirect_to @entity_info, notice: 'Entity info was successfully updated.' }
        format.json { render :show, status: :ok, location: @entity_info }
      else
        format.html { render :edit }
        format.json { render json: @entity_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_infos/1
  # DELETE /entity_infos/1.json
  def destroy
    @entity_info.destroy
    respond_to do |format|
      format.html { redirect_to entity_infos_url, notice: 'Entity info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_info
      @entity_info = EntityInfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_info_params
      params.require(:entity_info).permit(:assigned_code, :entity_name, :entity_alias, :entity_cat_id, :comment, :active_status, :del_status, :user_id)
    end
end
