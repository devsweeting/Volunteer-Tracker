class Cat
  attr_reader(:name, :breed)
  attr_writer(:address)
  attr_accessor(:age)

  def initialize(name, age, breed, address)
    @name = name
    @age = age
    @breed = breed
    @birthplace = birthplace
  end

  def meow
    puts "meow"
  end
end
