require('rspec')
require('pg')
require('movie')
require('patron')
require('rent')
require('pry')

DB = PG.connect({:dbname => "moviebox_test"})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM movies *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM rent *;")
  end
end
