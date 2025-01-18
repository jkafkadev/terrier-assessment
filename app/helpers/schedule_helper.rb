module ScheduleHelper
  def self.get_earliest_time
    earliest_work_order = WorkOrder.all.min_by { |e| e.time }
    earliest_work_order.time.hour
  end
  def self.get_latest_time
    latest_work_order = WorkOrder.all.max_by { |e| e.time + (e.duration * 60) }
    latest_time = latest_work_order.time + (latest_work_order.duration * 60)
    if latest_time.min != 0 then
      latest_time.hour + 1
    else
      latest_time.hour
    end
  end
  def self.get_overlap(work_order_1, work_order_2)
    if work_order_1["timeInMinutes"] > work_order_2["timeInMinutes"] && work_order_1["timeInMinutes"] < (work_order_2["timeInMinutes"] + work_order_2["duration"]) then
      work_order_2["overlap"] + 1
    else
      0
    end
  end
  def self.get_work_orders(technician = Technician)
    base_work_orders = WorkOrder.where(technician_id: technician.id).order(time: :asc).map { |workOrder|
      location = Location.find(workOrder.location_id)
      {
        "time" => workOrder.time,
        "timeInMinutes" => (workOrder.time.hour * 60 + workOrder.time.min),
        "location" => location.name,
        "city" => location.city,
        "duration" => workOrder.duration,
        "price" => workOrder.price
      }
    }
    work_orders = [ {
      "time" => base_work_orders[0]["time"],
      "timeInMinutes" => base_work_orders[0]["timeInMinutes"],
      "location" => base_work_orders[0]["location"],
      "city" => base_work_orders[0]["city"],
      "duration" => base_work_orders[0]["duration"],
      "price" => base_work_orders[0]["price"],
      "overlap" => 0
    } ]
    (1..(base_work_orders.length - 1)).each { |i|
      work_order = base_work_orders[i]
      work_orders += [ {
        "time" => work_order["time"],
        "timeInMinutes" => work_order["timeInMinutes"],
        "location" => work_order["location"],
        "city" => work_order["city"],
        "duration" => work_order["duration"],
        "price" => work_order["price"],
        "overlap" => get_overlap(work_order, work_orders[i-1])
      } ]
    }
    work_orders
  end
  def self.get_schedule_for_technician(technician = Technician)
    work_orders = get_work_orders technician
    earliest_time = get_earliest_time
    latest_time = get_latest_time
    # puts work_orders
    breaks = []
    if work_orders.length > 0 then
      first_order = work_orders[0]
      last_order = work_orders[work_orders.length - 1]
      last_break_time = last_order["time"] + (last_order["duration"].to_f * 60)
      last_break_timeInMinutes = (last_break_time.time.hour * 60 + last_break_time.time.min)
      if !(earliest_time == first_order["time"].hour && first_order["time"].min == 0) then
        breaks += [ {
          "time" => DateTime.new(first_order["time"].year, first_order["time"].month, first_order["time"].day, earliest_time),
          "timeInMinutes" => earliest_time * 60,
          "duration" => (first_order["time"].hour * 60 + first_order["time"].min) - (earliest_time * 60)
        } ]
      end
      if !(latest_time == last_break_time.hour && last_break_time.min == 0) then
        breaks += [ {
          "time" => last_break_time,
          "timeInMinutes" => last_break_timeInMinutes,
          "duration" => (latest_time * 60) - last_break_timeInMinutes
        } ]
      end
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
    {
      "technician" => technician,
      "columns" => (work_orders.max_by { |work_order| work_order["overlap"] })["overlap"],
      "work_orders" => work_orders,
      "breaks" => breaks
    }
  end
  def self.get_schedule
    Technician.all.map { |technician| get_schedule_for_technician technician }
  end
end
