require_relative 'nameable'
require_relative 'trimmer_decorator'
require_relative 'capitalize_decorator'

class Person < Nameable
  attr_reader :id
  attr_accessor :name, :age, :books, :rentals

  def initialize(age, name: 'Unknown', parent_permission: true)
    super()
    @id = Random.rand(1..1000)
    @name = name
    @age = age
    @parent_permission = parent_permission
    @rentals = []
  end

  private

  def of_age?
    return true if @age >= 18

    false
  end

  def add_rental(date, book)
    Rental.new(date, self, book)
  end

  public

  def can_use_services?
    of_age? || @parent_permission
  end

  def correct_name
    @name
  end
end
