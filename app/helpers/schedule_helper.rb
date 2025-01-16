module ScheduleHelper
  def self.get_schedule(technician = Technician)
    WorkOrder.where(technician_id: technician.id).order(time: :asc).map { |workOrder| {
      "time" => workOrder.time,
      "timeInMinutes" => (workOrder.time.hour * 60 + workOrder.time.min),
      "location" => Location.find(workOrder.location_id).name,
      "city" => Location.find(workOrder.location_id).city,
      "duration" => workOrder.duration,
      "price" => workOrder.price
    }}
  end
  def self.get_breaks(technician = Technician)
    work_orders = get_schedule technician
    # puts work_orders
    breaks = []
    if work_orders.length > 0 then
      first_order = work_orders[0]
      last_order = work_orders[work_orders.length - 1]
      last_break_time = last_order["time"] + (last_order["duration"].to_f * 60)
      last_break_timeInMinutes = (last_break_time.time.hour * 60 + last_break_time.time.min)
      breaks += [
        {
          "time" => DateTime.new(first_order["time"].year, first_order["time"].month, first_order["time"].day),
          "timeInMinutes" => 0,
          "duration" => (first_order["time"].hour * 60 + first_order["time"].min)
        },
        {
          "time" => last_break_time,
          "timeInMinutes" => last_break_timeInMinutes,
          "duration" => 1440 - last_break_timeInMinutes
        }
      ]
      puts breaks.length
    end
    (1..(work_orders.length - 1)).each do |i|
      start = work_orders[i-1]["time"] + (work_orders[i-1]["duration"].to_f * 60)
      duration = ((work_orders[i]["time"] - start).to_f / 60).to_i
      if duration > 0 then
        breaks += [ {
          "time" => start,
          "timeInMinutes" => (start.time.hour * 60 + start.time.min),
          "duration" => duration
        } ]
      end
    end
    breaks
  end
end
