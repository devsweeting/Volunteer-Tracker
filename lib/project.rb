class Project
  attr_accessor(:title, :volunteer_id)
  attr_reader(:id)

  def initialize(attributes)
    @title = grammar(attributes.fetch(:title))
    @volunteer_id = grammar(attributes.fetch(:volunteer_id))
    @id = attributes.fetch(:id) rescue nil
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each() do |project|
      title = project.fetch("title")
      volunteer_id = project.fetch("volunteer_id")
      id = project.fetch("id").to_i()
      projects.push(Project.new({:title => title, :volunteer_id => volunteer_id, :id => id}))
    end
    projects
  end

  def update(attributes)
    @title = attributes.fetch(:title)
    @volunteer_id = attributes.fetch(:volunteer_id)
    @id = self.id()
    DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
    DB.exec("UPDATE projects SET volunteer_id = '#{@volunteer_id}' WHERE id = #{@id};")
  end

  def self.find(id)
    returned_projects = DB.exec("SELECT * FROM projects WHERE id = #{id};")
    return_project = nil
    returned_projects.each() do |project|
      title = project.fetch("title")
      volunteer_id = project.fetch("volunteer_id")
      id = project.fetch("id").to_i()
      return_project = Project.new({:title => title, :volunteer_id => volunteer_id, :id => id})
    end
    return_project
  end

  def save
    result = DB.exec("INSERT INTO projects(title, volunteer_id) VALUES ('#{@title}', '#{@volunteer_id}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{self.id};")
  end

  def ==(another_project)
    self.title().==(another_project.title()).&(self.volunteer_id().==(another_project.volunteer_id())).&(self.genre().==(another_project.genre())).&(self.checkedout().==(another_project.checkedout()))
  end

  # def grammar (input)
  #   input.split.map(&:capitalize).join(' ')
  # end

  # def add_volunteer
  #   @volunteer_id.push(attributes)
  # end
end
