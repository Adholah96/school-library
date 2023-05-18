

class Person
  attr_reader :id
  attr_accessor :name, :age

  def initialize(age, name: 'unkown', parent_permission: true)
    @id = Random.rand(1..1001)
    @name = name
    @age = age
    @parent_permission = parent_permission
  end

  private

  def of_age?
    return true if @age >= 18

    false
  end

  public

  def can_use_services?
    of_age? || @parent_permission
  end
end
