require_relative 'nameable'
require_relative 'capitalize_decorator'
require_relative 'trimmer_decorator'
class Person < Nameable
  attr_reader :id
  attr_accessor :name, :age, :books, :rentals

  def initialize(age, name: 'unkown', parent_permission: true)
    super
    @id = Random.rand(1..1001)
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
