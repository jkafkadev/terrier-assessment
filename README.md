# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 3.4.1

  * Run `bundle install`

* Database creation

  * Run `rails db:create`

* Database initialization

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
