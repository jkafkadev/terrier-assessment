# Install and run

* Clone this repository

* Ensure Ruby 3.4.1 is installed

* Navigate to the repository directory

  * Run `bundle install`

  * Run `rails db:create`

  * Run `rails db:migrate`

* How to run the test suite

  * Run `rails test`

* How to import data

  * Run `rake load:clear` to clear the database

  * Either: make sure technicians.csv, locations.csv and work_orders.csv are all in the same directory, then

    run `rake load:all["<path_to_directory_with_csvs>"]` ex. `rake load:all["../data"]`

  * or run

    1. `rake load:technicians["<path_to_technicians.csv>"]` ex. `rake load:technicians["../data/technicians.csv"]`

    2. `rake load:locations["<path_to_locations.csv>"]`

    3. `rake load:workOrders["<path_to_work_orders.csv>"]`

* How to start web app

  * Run `rails s` and navigate to `localhost:3000`

## Approach

I didn't have any experience with Ruby or Rails prior to this project, so I followed this [guide](https://guides.rubyonrails.org/getting_started.html#deploying-to-production).

After getting through the database setup part, I started on the data ingestion rake tasks.

Then I worked through the bulk of the controller logic, getting a representation of all of the work orders for each technician.

Next was setting up a basic grid on the front end. It's a CSS grid with each row representing a minute, starting on the hour before/equal to the first work order from the data, and ending on the hour after/equal to the end of the last

In order to handle the available time popup, I decided to calculate invisible break objects in the controller and handle them in the front-end the same as the work orders, with the difference being it displays an empty div, and has the alert functionality.

The biggest challenge was figuring out how to handle overlapping work orders for a technician. I'm not in love with the way it ended up, but that's what the possible future improvements section is for! I ended up modifying the controller logic to add an "overlap" field to the work orders, which represents which column under a technician the work order should show up in. The way it's implemented could result in potentially having more columns than necessary. Ex: WO1: 12-1, WO2: 12:30-1:30, WO3: 1:15-1:45. WO3 doesn't overlap with WO1, but this would still result in 3 columns instead of the necessary two.

## Possible Improvements

In addition to the potential extra columns, I would also change it so the work orders without overlaps take up the whole width for the technician, whereas now they just sit in the first column.

I think it would be cool in the case of overlaps to have a button that suggests a new timeslot that fits in the schedule, and also allow the scheduling of new work orders, and the ability to re-schedule existing ones. This wouldn't be super challenging to implement in the backend, but I feel like that level of interactivity in the front-end would warrant a change to a framework such as React or Vue, to make front-end logic a bit easier to implement.

It could be cool to have it be live, with a bar indicating current time, and having buttons for technicians to check in/out of work orders, and keep track of the completed work orders and its stats, which could maybe lead to improving the accuracy of expected work order time