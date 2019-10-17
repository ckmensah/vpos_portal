class ActivitySubDivsController < ApplicationController
  before_action :set_activity_sub_div, only: [:show, :edit, :update, :destroy]

  # GET /activity_sub_divs
  # GET /activity_sub_divs.json
  def index
    @activity_sub_divs = ActivitySubDiv.all
  end

  # GET /activity_sub_divs/1
  # GET /activity_sub_divs/1.json
  def show
  end

  # GET /activity_sub_divs/new
  def new
    @activity_sub_div = ActivitySubDiv.new
  end

  # GET /activity_sub_divs/1/edit
  def edit
  end

  # POST /activity_sub_divs
  # POST /activity_sub_divs.json
  def create
    @activity_sub_div = ActivitySubDiv.new(activity_sub_div_params)

    respond_to do |format|
      if @activity_sub_div.save
        format.html { redirect_to @activity_sub_div, notice: 'Activity sub div was successfully created.' }
        format.json { render :show, status: :created, location: @activity_sub_div }
      else
        format.html { render :new }
        format.json { render json: @activity_sub_div.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_sub_divs/1
  # PATCH/PUT /activity_sub_divs/1.json
  def update
    respond_to do |format|
      if @activity_sub_div.update(activity_sub_div_params)
        format.html { redirect_to @activity_sub_div, notice: 'Activity sub div was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_sub_div }
      else
        format.html { render :edit }
        format.json { render json: @activity_sub_div.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_sub_divs/1
  # DELETE /activity_sub_divs/1.json
  def destroy
    @activity_sub_div.destroy
    respond_to do |format|
      format.html { redirect_to activity_sub_divs_url, notice: 'Activity sub div was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_sub_div
      @activity_sub_div = ActivitySubDiv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_sub_div_params
      params.require(:activity_sub_div).permit(:activity_div_id, :activity_time, :classification, :amount, :comment, :active_status, :del_status, :user_id)
    end
end
