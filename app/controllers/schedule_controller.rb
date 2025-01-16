class ScheduleController < ApplicationController
  def index
    @schedule_by_technician = ScheduleHelper.get_schedule
  end
end
