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

# render a project page
get ('/edit_project/:id') do
  uid = params[:id].to_i
  @project = Project.find(uid)
  erb (:edit_project)
end

# update a project
patch ('/edit_project/:id') do
  title = params.fetch("title")
  uid = params[:id].to_i
  @project = Project.find(uid)
  @project.update({:title => title, :id => nil})
  @projects = Project.all
  @volunteers = Volunteer.all
  erb (:index)
end

# delete a project
delete ('/edit_project/:id') do
  @project = Project.find(params.fetch("id").to_i())
  @project.delete
  @projects = Project.all
  @volunteers = Volunteer.all
  erb (:index)
end
#  ----------------------------------------

#  --------  Volunteer routes  ------------

post ('/add_volunteer') do
  name = params.fetch("name")
  project_id = params.fetch("project_id")
  volunteer = Volunteer.new({:name => name, :project_id => project_id, :id => nil})
  volunteer.save
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:index)
end

# render a volunteer page
get ('/edit_volunteer/:id') do
  uid = params[:id].to_i
  @volunteer = Volunteer.find(uid)
  @projects = Project.all
  erb (:edit_volunteer)
end

# update volunteers info
patch ('/edit_volunteer/:id') do
  name = params.fetch("name")
  project_id = params.fetch("project_id").to_i
  uid = params[:id].to_i
  @volunteer = Volunteer.find(uid)
  @volunteer.update({:name => name, :project_id => project_id, :id => nil})
  @projects = Project.all
  @volunteers = Volunteer.all
  erb (:index)
end

# delete a project
delete ('/edit_volunteer/:id') do
  @volunteer = Volunteer.find(params.fetch("id"))
  @volunteer.delete
  @projects = Project.all
  @volunteers = Volunteer.all
  erb (:index)
end
#  ----------------------------------------
