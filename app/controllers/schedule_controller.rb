class ScheduleController < ApplicationController
  def index
    @schedule_by_technician = ScheduleHelper.get_schedule
    @earliest_time = ScheduleHelper.get_earliest_time
    @latest_time = ScheduleHelper.get_latest_time
  end
end
