class SubActivityMastersController < ApplicationController
  before_action :set_sub_activity_master, only: [:show, :edit, :update, :destroy]

  # GET /sub_activity_masters
  # GET /sub_activity_masters.json

  def index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @sub_activity_masters = SubActivityMaster.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end


  def sub_activity_master_index
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    @sub_activity_masters = SubActivityMaster.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
  end

  # GET /sub_activity_masters/1
  # GET /sub_activity_masters/1.json
  def show
  end

  # GET /sub_activity_masters/new
  def new
    @sub_activity_master = SubActivityMaster.new
  end

  # GET /sub_activity_masters/1/edit
  def edit
  end

  # POST /sub_activity_masters
  # POST /sub_activity_masters.json
  def create
    @sub_activity_master = SubActivityMaster.new(sub_activity_master_params)

    respond_to do |format|
      if @sub_activity_master.save
        format.html { redirect_to @sub_activity_master, notice: 'Sub activity master was successfully created.' }
        flash.now[:notice] = "Activity Code was successfully created."
        format.js { render :show }
        format.json { render :show, status: :created, location: @sub_activity_master }
      else
        format.html { render :new }
        format.js { render :new }
        format.json { render json: @sub_activity_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_activity_masters/1
  # PATCH/PUT /sub_activity_masters/1.json
  def update
    respond_to do |format|
      if @sub_activity_master.update(sub_activity_master_params)
        format.html { redirect_to @sub_activity_master, notice: 'Sub activity master was successfully updated.' }
        flash.now[:notice] = "Activity Code was successfully updated."
        format.js { render :show }
        format.json { render :show, status: :ok, location: @sub_activity_master }
      else
        format.html { render :edit }
        format.js { render :edit }
        format.json { render json: @sub_activity_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_activity_masters/1
  # DELETE /sub_activity_masters/1.json

  def destroy
    params[:count] ? params[:count] : params[:count] = 50
    params[:page] ? params[:page] : params[:page] = 1

    if @sub_activity_master.active_status
      @sub_activity_master.active_status = false
      @sub_activity_master.save(validate: false)
      @sub_activity_masters = SubActivityMaster.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Occupation master was successfully disabled.' }
        flash.now[:note] = 'Activity Code was successfully disabled.'
        format.js { render :layout => false}
        format.json { head :no_content }
        # window.location.href = "<%= recipe_path(@recipe) %>"
      end

    else
      @sub_activity_master.active_status = true
      @sub_activity_master.save(validate: false)
      @sub_activity_masters = SubActivityMaster.paginate(:page => params[:page], :per_page => params[:count]).order('created_at desc')
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Allergy master was successfully enabled.' }
        flash.now[:notice] = 'Activity Code was successfully enabled.'
        format.js { render :layout => false }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_activity_master
      #@sub_activity_master = SubActivityMaster.find(params[:id])
      @sub_activity_master = SubActivityMaster.where(assigned_code: params[:id]).order('id desc').first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_activity_master_params
      params.require(:sub_activity_master).permit(:assigned_code, :activity_desc, :user_id, :active_status, :del_status)
    end
end
