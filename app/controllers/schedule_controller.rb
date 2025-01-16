class ScheduleController < ApplicationController
  def index
    @technicians = Technician.all
    @locations = Location.all
    @schedule_by_technician =
      @technicians
        .clone()
        .map { |technician|
          {
            "technician" => technician,
            "work_orders" => (ScheduleHelper.get_schedule technician),
            "breaks" => (ScheduleHelper.get_breaks technician)
          }
        }
  end
end
