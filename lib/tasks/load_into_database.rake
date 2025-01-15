require "csv"

def load_technicians(path = string)
  puts "Initial Technicians #{Technician.all.count}"
  csv_text = File.read(path)
  csv = CSV.parse(csv_text, headers: true)
  csv.each do |row|
    if Technician.where(id: row[0]) != [] then
      puts "Technician #{row[0]}: #{row[1]} already exists."
    else
      Technician.create!(id: row[0], name: row[1])
      puts "Added Technician #{row[0]}: #{row[1]}"
    end
  end
end

def load_locations(path = string)
  puts "Initial Locations #{Location.all.count}"
  csv_text = File.read(path)
  csv = CSV.parse(csv_text, headers: true)
  csv.each do |row|
    if Location.where(id: row[0]) != [] then
      puts "Location #{row[0]}: #{row[1]}, #{row[2]} already exists."
    else
      Location.create!(id: row[0], name: row[1], city: row[2])
      puts "Added Location #{row[0]}: #{row[1]}, #{row[2]}"
    end
  end
end

def load_work_orders(path = string)
  puts "initial Work Orders #{WorkOrder.all.count}"
  csv_text = File.read(path)
  csv = CSV.parse(csv_text, headers: true)
  csv.each do |row|
    if WorkOrder.where(id: row[0]) != [] then
      puts "WorkOrder #{row[0]} already exists."
    else
      WorkOrder.create!(id: row[0], technician_id: row[1], location_id: row[2], time: row[3], duration: row[4], price: row[5])
      puts "Added WorkOrder #{row[0]}: Technician #{row[1]}, Location #{row[2]}, Time #{row[3]}, Duration #{row[4]}, Price #{row[5]}"
    end
  end
end

def clear
    puts "Clearing database"
    WorkOrder.destroy_all
    Location.destroy_all
    Technician.destroy_all
end

namespace :load do
  desc "Load database from csv files"

  task :technicians, [ :path ] => [ :environment ] do |t, args|
    load_technicians args[:path]
  end

  task :locations, [ :path ] => [ :environment ] do |t, args|
    load_locations args[:path]
  end

  task :workOrders, [ :path ] => [ :environment ] do |t, args|
    load_work_orders args[:path]
  end

  task :all, [ :path ] => [ :environment ] do |t, args|
    load_technicians (args[:path] + "/technicians.csv")
    load_locations (args[:path] + "/locations.csv")
    load_work_orders (args[:path] + "/work_orders.csv")
  end
  task clear: [ :environment ] do
    clear
  end
end
