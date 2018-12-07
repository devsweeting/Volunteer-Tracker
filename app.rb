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

# Get project page
get ('/edit_project/:id') do
  uid = params[:id].to_i
  @project = Project.find(uid)
  erb (:edit_project)
end

# update project
patch ('/edit_project/:id') do
  title = params.fetch("title")
  uid = params[:id].to_i
  @project = Project.find(uid)
  @project.update({:title => title, :id => nil})
  @projects = Project.all
  @volunteers = Volunteer.all
  binding.pry
  erb (:index)
end
#  ----------------------------------------
