class ActivityDivsController < ApplicationController
  before_action :set_activity_div, only: [:show, :edit, :update, :destroy]

  # GET /activity_divs
  # GET /activity_divs.json
  def index
    @activity_divs = ActivityDiv.all
  end

  # GET /activity_divs/1
  # GET /activity_divs/1.json
  def show
  end

  # GET /activity_divs/new
  def new
    @activity_div = ActivityDiv.new
  end

  # GET /activity_divs/1/edit
  def edit
  end

  # POST /activity_divs
  # POST /activity_divs.json
  def create
    @activity_div = ActivityDiv.new(activity_div_params)

    respond_to do |format|
      if @activity_div.save
        format.html { redirect_to @activity_div, notice: 'Activity div was successfully created.' }
        format.json { render :show, status: :created, location: @activity_div }
      else
        format.html { render :new }
        format.json { render json: @activity_div.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_divs/1
  # PATCH/PUT /activity_divs/1.json
  def update
    respond_to do |format|
      if @activity_div.update(activity_div_params)
        format.html { redirect_to @activity_div, notice: 'Activity div was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_div }
      else
        format.html { render :edit }
        format.json { render json: @activity_div.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_divs/1
  # DELETE /activity_divs/1.json
  def destroy

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_div
      @activity_div = ActivityDiv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_div_params
      params.require(:activity_div).permit(:division_code, :activity_div_desc, :activity_date, :comment, :active_status, :del_status, :user_id)
    end
end
