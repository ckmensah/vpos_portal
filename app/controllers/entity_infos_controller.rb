class EntityInfosController < ApplicationController
  before_action :set_entity_info, only: [:show, :edit, :update, :destroy]

  # GET /entity_infos
  # GET /entity_infos.json
  def index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
    @entity_divisions = EntityDivision.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  def entity_info_index
    params[:count] ? params[:count] : params[:count] = 10
    params[:page] ? params[:page] : params[:page] = 1

    @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')

  end

  # GET /entity_infos/1
  # GET /entity_infos/1.json
  def show
  end

  # GET /entity_infos/new
  def new
    @entity_info = EntityInfo.new
    @entity_info.entity_info_extras.build
    @entity_categories = EntityCategory.where(active_status: true).order(assigned_code: :asc)
  end

  # GET /entity_infos/1/edit
  def edit
    # @entity_info.entity_info_extras.first
    # @entity_info_extra = @entity_info.entity_info_extras.build
    @new_record = EntityInfo.new
    @new_record.entity_info_extras.build
    @entity_info_extra = @entity_info.entity_info_extras.where(active_status: true, del_status: false).order(created_at: :desc).first
    logger.info "Edit build 1 #{@entity_info_extra.inspect}"
    @entity_categories = EntityCategory.where(active_status: true).order(assigned_code: :asc)
  end

  # POST /entity_infos
  # POST /entity_infos.json

  def create
    @entity_info = EntityInfo.new(entity_info_params)
    if entity_info_params[:action_type] != "for_update"
      @entity_info.assigned_code = EntityInfo.gen_entity_info_code
      logger.info "The Entity Information code is #{@entity_info.assigned_code.inspect}"
    end
    @entity_categories = EntityCategory.where(active_status: true).order(assigned_code: :asc)
    respond_to do |format|
      if @entity_info.valid?
        if entity_info_params[:action_type] == "for_update"
          logger.info "UPDATING IN CREATE......... INTERESTING"
          EntityInfo.update_last_but_one('entity_info', 'assigned_code', @entity_info.assigned_code)
          EntityInfo.update_last_but_one('entity_info_extra', 'entity_code', @entity_info.assigned_code)
        end
        format.html { redirect_to @entity_info, notice: 'Entity info was successfully created.' }
        flash.now[:danger] = "Entity info was successfully created."
        format.js { render :show}
        format.json { render :show, status: :created, location: @entity_info }
      else
        format.html { render :new }
        format.js {render :new }
        format.json { render json: @entity_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entity_infos/1
  # PATCH/PUT /entity_infos/1.json

  def update
    # @new_record = @entity_info
    @new_record = EntityInfo.new(entity_info_params)
    # @new_extra = EntityInfoExtra.new(entity_info_params[:entity_info_extra])
    # # @entity_info_extra = @entity_info.entity_info_extras.first
    # @entity_info_extra = @entity_info.entity_info_extras.where(active_status: true, del_status: false).order(created_at: :desc).first
    # logger.info "Edit build 2 #{@entity_info_extra.inspect}"
    # logger.info "#{@new_record.inspect}"
    # @entity_info = @new_record
    respond_to do |format|
      if @new_record.valid? #(validate: false) # @entity_info.update(entity_info_params)
      # @entity_info = @new_record
      # EntityInfo.update_last_but_one('entity_info', 'assigned_code', @entity_info.assigned_code)
        format.html { redirect_to @entity_info, notice: 'Entity info was successfully updated.' }
        flash.now[:danger] = "Entity info was successfully updated."
        format.js { render :show}
        format.json { render :show, status: :ok, location: @entity_info }
      else
        @new_extra.valid?
        @entity_info.valid?
        @entity_categories = EntityCategory.where(active_status: true).order(assigned_code: :asc)
        format.html { render :edit }
        format.js {render :edit }
        format.json { render json: @entity_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_infos/1
  # DELETE /entity_infos/1.json

  def destroy
    if @entity_info.active_status
      EntityInfo.disable_by_update_onef("entity_info","assigned_code",@entity_info.assigned_code)
      @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_infos_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Entity information was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      EntityInfo.enable_by_update_onet("entity_info","assigned_code",@entity_info.assigned_code)
      @entity_infos = EntityInfo.where(del_status: false).paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to entity_infos_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Entity information was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_info
      # @entity_info = EntityInfo.find(params[:id])
      @entity_info = EntityInfo.where(assigned_code: params[:id], active_status: true, del_status: false).order('id desc').first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_info_params
      params.require(:entity_info).permit(:assigned_code, :entity_name, :entity_alias, :entity_cat_id, :action_type, :comment, :active_status, :del_status, :user_id,
                                          entity_info_extras_attributes: [:id, :entity_code, :contact_number, :web_url, :contact_email, :location_address, :postal_address, :comment, :active_status, :del_status, :user_id])
    end
end
