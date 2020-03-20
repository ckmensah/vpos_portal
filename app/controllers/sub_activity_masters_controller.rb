class SubActivityMastersController < ApplicationController
  before_action :set_sub_activity_master, only: [:show, :edit, :update, :destroy]

  # GET /sub_activity_masters
  # GET /sub_activity_masters.json
  def index
    @sub_activity_masters = SubActivityMaster.all
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
        format.json { render :show, status: :created, location: @sub_activity_master }
      else
        format.html { render :new }
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
        format.json { render :show, status: :ok, location: @sub_activity_master }
      else
        format.html { render :edit }
        format.json { render json: @sub_activity_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_activity_masters/1
  # DELETE /sub_activity_masters/1.json
  def destroy
    @sub_activity_master.destroy
    respond_to do |format|
      format.html { redirect_to sub_activity_masters_url, notice: 'Sub activity master was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_activity_master
      @sub_activity_master = SubActivityMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_activity_master_params
      params.require(:sub_activity_master).permit(:assigned_code, :activity_desc, :user_id, :active_status, :del_status)
    end
end
