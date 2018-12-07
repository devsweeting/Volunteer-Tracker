require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/project")
require("./lib/volunteer")
require("pg")
require("pry")

DB = PG.connect({:dbname => "volunteer_tracker"})

get ('/') do
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:index)
end

# --------  Project routes  ----------------
post ('/create_project') do
  title = params.fetch("title")
  project = Project.new({:title => title, :id => nil})
  project.save
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:index)
end

get ('/create_project/:id') do
  uid = params[:id].to_i
  @movie = Movie.find(uid)
  erb (:edit_project)
end

#  ----------------------------------------
