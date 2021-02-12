class EntityDivSocialHandlesController < ApplicationController
  before_action :set_entity_div_social_handle, only: [:show, :edit, :update, :destroy]

  # GET /entity_div_social_handles
  # GET /entity_div_social_handles.json
  def index
    @entity_div_social_handles = EntityDivSocialHandle.all
  end

  def entity_div_social_handle_index
    @entity_div_social_handles = EntityDivSocialHandle.where(entity_div_code: params[:code], del_status: false).order(created_at: :desc)
  end
  # GET /entity_div_social_handles/1
  # GET /entity_div_social_handles/1.json
  def show
  end

  # GET /entity_div_social_handles/new
  def new
    @entity_div_social_handle = EntityDivSocialHandle.new
  end

  # GET /entity_div_social_handles/1/edit
  def edit
    if @entity_div_social_handle.active_status && @entity_div_social_handle.del_status == false
    else
      @new_social_handle = EntityDivSocialHandle.where(entity_div_code: params[:code], assigned_code: @entity_div_social_handle.assigned_code, active_status: true).order(created_at: :desc).first

      if @new_social_handle
        @entity_div_social_handle = @new_social_handle
      else
        @disabled_social_handle = EntityDivSocialHandle.where(entity_div_code: params[:code], assigned_code: @entity_div_social_handle.assigned_code, active_status: false).order(created_at: :desc).first
        flash.now[:notice] = "Sorry, this Handle has been disabled. Kindly enable it before editing."
        @entity_div_social_handle = nil
      end
    end
  end

  # POST /entity_div_social_handles
  # POST /entity_div_social_handles.json
  #def create
  #  @entity_div_social_handle = EntityDivSocialHandle.new(entity_div_social_handle_params)
  #
  #  respond_to do |format|
  #    if @entity_div_social_handle.save
  #      format.html { redirect_to @entity_div_social_handle, notice: 'Entity div social handle was successfully created.' }
  #      format.json { render :show, status: :created, location: @entity_div_social_handle }
  #    else
  #      format.html { render :new }
  #      format.json { render json: @entity_div_social_handle.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # PATCH/PUT /entity_div_social_handles/1
  # PATCH/PUT /entity_div_social_handles/1.json
  def update
    respond_to do |format|
      assigned_code = @entity_div_social_handle.assigned_code
      date = @entity_div_social_handle.created_at.strftime('%Y-%m-%d %H:%M:%S.%N')
      updated_date = @entity_div_social_handle.updated_at.strftime('%Y-%m-%d %H:%M:%S.%N')
      social_handle = EntityDivSocialHandle.media_handle_desc(assigned_code)
      if entity_div_social_handle_params[:handle].present?
        if @entity_div_social_handle.handle != entity_div_social_handle_params[:handle]
          sql = "UPDATE entity_div_social_handle SET active_status = false, del_status = true, updated_at = '#{updated_date}' WHERE id = #{@entity_div_social_handle.id}"
          ActiveRecord::Base.connection.execute(sql)
          #if @entity_div_social_handle.update(active_status: false, del_status: true, updated_at: updated_date)
            @entity_div_social_handle = EntityDivSocialHandle.new(assigned_code: assigned_code, entity_div_code: params[:code],
                                                                  handle: entity_div_social_handle_params[:handle],
                                                                  active_status: true, del_status: false,
                                                                  user_id: current_user.id, created_at: date)
            @entity_div_social_handle.save(validate: false)
            flash.now[:notice] = "#{social_handle} handle has been updated successfully."
            format.js { render :show }
          #else
          #  @entity_div_social_handle.handle = entity_div_social_handle_params[:handle]
          #  flash.now[:danger] = "Update failed. Kindly try again."
          #  format.js { render :edit }
          #end
        else
          flash.now[:danger] = "No edit has been made. Kindly try again."
          format.js { render :edit }
        end
      else
        @entity_div_social_handle.handle = entity_div_social_handle_params[:handle]
        flash.now[:danger] = "No handle was entered for #{social_handle}."
        format.js { render :edit }
      end
    end
  end

  # DELETE /entity_div_social_handles/1
  # DELETE /entity_div_social_handles/1.json
  def destroy
    social_handle_name = EntityDivSocialHandle.media_handle_desc(@entity_div_social_handle.assigned_code)
    if @entity_div_social_handle.active_status && @entity_div_social_handle.del_status == false
      @entity_div_social_handle.active_status = false
      @entity_div_social_handle.save(validate: false)
      @entity_div_social_handles = EntityDivSocialHandle.where(entity_div_code: params[:code], del_status: false).order(created_at: :desc)
      respond_to do |format|
        flash.now[:note] = "#{social_handle_name} was successfully disabled."
        format.js { render :layout => false}
      end

    elsif @entity_div_social_handle.active_status == false && @entity_div_social_handle.del_status == false
      @entity_div_social_handle.active_status = true
      @entity_div_social_handle.save(validate: false)
      @entity_div_social_handles = EntityDivSocialHandle.where(entity_div_code: params[:code], del_status: false).order(created_at: :desc)
      respond_to do |format|
        flash.now[:notice] = "#{social_handle_name} was successfully enabled."
        format.js { render :layout => false }
      end

    else
      respond_to do |format|
        flash.now[:notice] = 'Please try again.'
        format.js { render :layout => false }
      end
      @entity_div_social_handles = EntityDivSocialHandle.where(entity_div_code: params[:code], del_status: false).order(created_at: :desc)
    end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity_div_social_handle
      @entity_div_social_handle = EntityDivSocialHandle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entity_div_social_handle_params
      params.require(:entity_div_social_handle).permit(:entity_div_code, :assigned_code, :handle, :active_status, :del_status, :user_id)
    end
end
