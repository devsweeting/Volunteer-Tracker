class Volunteer
  attr_accessor(:name, :project_id)
  attr_reader(:id)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @project_id = attributes.fetch(:project_id)
    @id = attributes.fetch(:id) rescue nil
  end

  def self.all
    returned_volunteers = DB.exec("SELECT * FROM volunteers;")
    volunteers = []
    returned_volunteers.each() do |volunteer|
      name = volunteer.fetch("name")
      project_id = volunteer.fetch("project_id").to_i
      id = volunteer.fetch("id").to_i
      volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
    end
    volunteers
  end

  def update(attributes)
    @name = attributes.fetch(:name)
    @project_id = attributes.fetch(:project_id)
    @id = self.id()
    DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id};")
    DB.exec("UPDATE volunteers SET project_id = '#{@project_id}' WHERE id = #{@id};")
  end

  def self.find(id)
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE id = #{id};")
    return_volunteer = nil
    returned_volunteers.each() do |volunteer|
      name = volunteer.fetch("name")
      project_id = volunteer.fetch("project_id")
      id = volunteer.fetch("id").to_i()
      return_volunteer = Volunteer.new({:name => name, :project_id => project_id, :id => id})
    end
    return_volunteer
  end

  def save
    result = DB.exec("INSERT INTO volunteers(name, project_id) VALUES ('#{@name}', '#{project_id}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def delete
    DB.exec("DELETE FROM volunteers WHERE id = #{self.id};")
  end

  def ==(another_volunteer)
    self.name.==(another_volunteer.name).&self.project_id.==(another_volunteer.project_id)
  end
end
