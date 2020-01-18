class ActivitySubDivClassesController < ApplicationController
  before_action :set_activity_sub_div_class, only: [:show, :edit, :update, :destroy]

  # GET /activity_sub_div_classes
  # GET /activity_sub_div_classes.json
  def index
    @activity_sub_div_classes = ActivitySubDivClass.all
  end

  # GET /activity_sub_div_classes/1
  # GET /activity_sub_div_classes/1.json
  def show
  end

  # GET /activity_sub_div_classes/new
  def new
    @activity_sub_div_class = ActivitySubDivClass.new
  end

  # GET /activity_sub_div_classes/1/edit
  def edit
  end

  # POST /activity_sub_div_classes
  # POST /activity_sub_div_classes.json
  def create
    @activity_sub_div_class = ActivitySubDivClass.new(activity_sub_div_class_params)

    respond_to do |format|
      if @activity_sub_div_class.save
        format.html { redirect_to @activity_sub_div_class, notice: 'Activity sub div class was successfully created.' }
        format.json { render :show, status: :created, location: @activity_sub_div_class }
      else
        format.html { render :new }
        format.json { render json: @activity_sub_div_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_sub_div_classes/1
  # PATCH/PUT /activity_sub_div_classes/1.json
  def update
    respond_to do |format|
      if @activity_sub_div_class.update(activity_sub_div_class_params)
        format.html { redirect_to @activity_sub_div_class, notice: 'Activity sub div class was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_sub_div_class }
      else
        format.html { render :edit }
        format.json { render json: @activity_sub_div_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_sub_div_classes/1
  # DELETE /activity_sub_div_classes/1.json
  def destroy
    @activity_sub_div_class.destroy
    respond_to do |format|
      format.html { redirect_to activity_sub_div_classes_url, notice: 'Activity sub div class was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_sub_div_class
      @activity_sub_div_class = ActivitySubDivClass.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_sub_div_class_params
      params.require(:activity_sub_div_class).permit(:entity_div_code, :class_desc, :comment, :active_status, :del_status, :user_id)
    end
end
