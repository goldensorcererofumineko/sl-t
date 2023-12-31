class SleepMsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_sleep, only: [:show, :edit, :update, :destroy]
  def index
    @sleep_ms = SleepM.all
    if @sleep_ms.present?
      total_sleep_duration = 0
      @sleep_ms.each do |sleep_m|
        total_sleep_duration += sleep_m.sleep_duration_minutes
      end
      average_sleep_duration_minutes = total_sleep_duration / @sleep_ms.length
      @average_sleep_duration_hours = average_sleep_duration_minutes / 60
      @average_sleep_duration_minutes = average_sleep_duration_minutes % 60
    else
      @average_sleep_duration_hours = 0
      @average_sleep_duration_minutes = 0
    end
    @weekly_quality_counts = SleepM.where(created_at: Time.now.beginning_of_week..Time.now.end_of_week)
    .group(:quality).count
  
    # 以下のコードで月ごとの平均睡眠時間を計算
    grouped_sleep_data = @sleep_ms.group_by { |sleep_m| sleep_m.set_time.beginning_of_month }
    @monthly_average_sleep = {}
    grouped_sleep_data.each do |month, sleep_data|
      total_sleep_duration = sleep_data.sum { |sleep_m| sleep_m.sleep_duration_minutes }
      average_sleep_duration_minutes = total_sleep_duration / sleep_data.length
      @monthly_average_sleep[month] = {
        hours: average_sleep_duration_minutes / 60,
        minutes: average_sleep_duration_minutes % 60
      }
    end

    grouped_sleep_data = @sleep_ms.group_by { |sleep_m| sleep_m.set_time.beginning_of_week }
    @weekly_average_sleep = {}
    grouped_sleep_data.each do |week, sleep_data|
      total_sleep_duration = sleep_data.sum { |sleep_m| sleep_m.sleep_duration_minutes }
      average_sleep_duration_minutes = total_sleep_duration / sleep_data.length
      @weekly_average_sleep[week] = {
        hours: average_sleep_duration_minutes / 60,
        minutes: average_sleep_duration_minutes % 60
      }
    end
  end
  
  
  def show
    @sleep_m = SleepM.find(params[:id])
    if @sleep_m.set_time
      @sleep_ms_data = SleepM.where(set_time: @sleep_m.set_time.to_date).order(set_time: :asc)
    else
      @sleep_ms_data = []
    end
  
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
    if @sleep_m.update(sleep_params)
      redirect_to sleep_m_path(@sleep_m)
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
    params.require(:sleep_m).permit(:set_time, :end_time, :quality, :memo).merge(user_id: current_user.id)
  end

end
