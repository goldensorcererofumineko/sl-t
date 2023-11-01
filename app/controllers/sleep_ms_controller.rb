class SleepMsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_sleep, only: [:show, :edit, :update, :destroy]
  def index
    @sleep_ms = SleepM.all
    if @sleep_ms.present? 
      total_sleep_duration = @sleep_ms.sum { |sleep_m| sleep_m.sleep_duration.to_i }
      average_sleep_duration_minutes = total_sleep_duration / @sleep_ms.length
      @average_sleep_duration_hours = average_sleep_duration_minutes / 60
      @average_sleep_duration_minutes = average_sleep_duration_minutes % 60
    else
      @average_sleep_duration_hours = 0
      @average_sleep_duration_minutes = 0
    end
  end
  def show
    @sleep_ms_data = SleepM.where(record_date: @sleep_m.record_date).order(set_time: :asc)

    # 他の必要な処理を追加
  
    respond_to do |format|
      format.html
    end
  
  end

  def new
    @sleep_m = SleepM.new
  end

  def create
    @sleep_m = SleepM.new(sleep_params)
    if @sleep_m.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @sleep_m = SleepM.find(params[:id])
    if sleep_m.update(sleep_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @sleep_m = SleepM.find(params[:id])
    @sleep_m.destroy
    redirect_to root_path
  end

  private

  def set_sleep
    @sleep_m = SleepM.find(params[:id])
  end

  def sleep_params
    params.require(:sleep_m).permit(:record_date, :set_time, :end_time, :quality, :memo).merge(user_id: current_user.id)
  end

end
