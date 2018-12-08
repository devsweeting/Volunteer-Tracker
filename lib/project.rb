class Project
  attr_accessor(:title)
  attr_reader(:id)

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id) rescue nil
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each() do |project|
      title = project.fetch("title")
      id = project.fetch("id").to_i()
      projects.push(Project.new({:title => title, :id => id}))
    end
    projects
  end

  def update(attributes)
    @title = attributes.fetch(:title)
    @id = self.id()
    DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
  end

  def self.find(id)
    returned_projects = DB.exec("SELECT * FROM projects WHERE id = #{id};")
    return_project = nil
    returned_projects.each() do |project|
      title = project.fetch("title")
      id = project.fetch("id").to_i()
      return_project = Project.new({:title => title, :id => id})
    end
    return_project
  end

  def save
    result = DB.exec("INSERT INTO projects(title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{self.id};")
  end

  def ==(another_project)
    self.title.==(another_project.title)
  end

  def volunteers
    project_volunteers = []
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id};")
    returned_volunteers.each do |volunteer|
      name = volunteer.fetch("name")
      project_id = volunteer.fetch("project_id").to_i
      project_volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => nil}))
    end
    project_volunteers
  end


end
