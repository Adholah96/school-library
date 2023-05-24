require_relative 'person'
require_relative 'classroom'
require_relative 'book'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'
require 'json'

def list_all_books(books)
  puts 'List of books:'
  puts
  books.each_with_index do |book, index|
    puts "#{index + 1}. Title: #{book.title}, Author: #{book.author}"
    puts
  end
end

def list_all_people(people)
  puts 'List of people:'
  puts
  people.each_with_index do |person, index|
    person_type = person.instance_of?(Student) ? '[Student]' : '[Teacher]'
    puts "#{index + 1}. #{person_type} Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
    puts
  end
end

def write_file(data,path)
  if File.exist?(path)
    file = File.open(path, 'a')
    file.puts(data.to_json)
    file.close
  else
    file = File.open(path, 'w')
    file.puts(data.to_json)
    file.close
  end
end

def create_person(people)
  puts 'Select person type:'
  puts '1. Student'
  puts '2. Teacher'
  print 'Choice: '
  type = gets.chomp.to_i
  case type
  when 1
    create_student(people)
  when 2
    create_teacher(people)
  else
    puts 'Invalid option!'
  end
end

def create_student(people)
  print 'Age: '
  age = gets.chomp.to_i
  print 'Name: '
  name = gets.chomp
  print 'Has parent permission? (Y/N): '
  permission = gets.chomp == 'Y'
  student_classroom = Classroom.new('Classroom 1')
  person = Student.new(age, student_classroom, name: name, parent_permission: permission)
  people.push(person)
  student_classroom.students.push(person) # Add the student to the classroom
  student_data = {
    'age' => age,  
    'name' => name, 
    'parent_permission' => permission,
  }
  path = './data/student.json'
  write_file(student_data,path)
  puts 'Person created successfully!'
  puts
end

def create_teacher(people)
  print 'Age: '
  age = gets.chomp.to_i
  print 'Name: '
  name = gets.chomp
  print 'Specialization: '
  specialization = gets.chomp
  person = Teacher.new(age, specialization, name: name)
  people.push(person)
  teacher_data = {
    "age" => age,
    "specialization" => specialization, 
    "name" => name, 
  }
  path = './data/teacher.json'
  write_file(teacher_data,path)
  puts 'Person created successfully!'
  puts
end

def create_book(books)
  print 'Title: '
  title = gets.chomp
  print 'Author: '
  author = gets.chomp
  books.push(Book.new(title, author))
  book_data = {
    "title" => title, 
    "author" => author,
  }
  path = './data/book.json'
  write_file(book_data,path)
  puts 'Book created successfully!'
  puts
end

def create_rental(people, books, rentals)
  selected_book = select_book(books)
  selected_person = select_person(people)
  return unless selected_book && selected_person

  print 'Date: '
  date = gets.chomp
  create_rental_entry(date, selected_book, selected_person, rentals)
  rental_data = {
    "date" => date, 
    "selected_book" => {
      "title" => selected_book.title,
      "author" => selected_book.author,
    }, 
    "selected_person" => {
      "name" => selected_person.name,
      "id" => selected_person.id,
      "age" => selected_person.age,
    }, 
    "rentals" => {
      "date" => date
    }, 
  }
  path = './data/rentals.json'
  write_file(rental_data,path)
end

def select_book(books)
  puts 'Select a book from the following list by number'
  list_all_books(books)
  print 'Book number: '
  book_index = gets.chomp.to_i
  selected_book = books[book_index - 1]
  if selected_book.nil?
    puts 'Invalid book number!'
    return nil
  end
  selected_book
end

def select_person(people)
  puts 'Select a person from the following list by number (not ID) or create a new person'
  list_all_people(people)
  print 'Person number: '
  person_index = gets.chomp.to_i
  selected_person = people[person_index - 1]
  if selected_person.nil?
    puts 'Invalid person number!'
    return nil
  end
  selected_person
end

def create_rental_entry(date, selected_book, selected_person, rentals)
  rentals.push(Rental.new(date, selected_book, selected_person))
  puts 'Rental created successfully!'
  puts
end

def list_rentals(rentals)
  puts 'List of rentals:'
  puts
  puts 'Enter the Person ID to see their rentals:'
  person_id = gets.chomp.to_i
  puts

  rentals.each_with_index do |rental, _index|
    print_rental_info(rental, person_id)
  end
end

def print_rental_info(rental, person_id)
  return unless rental.person.id == person_id

  book_info = "Book: #{rental.book.title} by #{rental.book.author}"
  person_info = "Person: #{rental.person.name}"
  date_info = "Date: #{rental.date}"
  age_info = "Age: #{rental.person.age}"
  puts "#{rental.person.id}. #{book_info} - #{person_info} - #{date_info} - #{age_info}"
  puts
end

def quit
  puts 'Goodbye!'
end

def main
  books = []
  people = []
  rentals = []
  loop do
    display_menu
    option = gets.chomp.to_i
    puts ''
    handle_option(option, books, people, rentals)
    break if option == 7
  end
end

def display_menu
  puts 'Library Management System'
  puts '1. List all books'
  puts '2. List all people'
  puts '3. Create a person'
  puts '4. Create a book'
  puts '5. Create a rental'
  puts '6. List rentals for a person'
  puts '7. Quit'
  print 'Select an option: '
end

def handle_option(option, books, people, rentals)
  option_actions = {
    1 => -> { list_all_books(books) },
    2 => -> { list_all_people(people) },
    3 => -> { create_person(people) },
    4 => -> { create_book(books) },
    5 => -> { create_rental(people, books, rentals) },
    6 => -> { list_rentals(rentals) },
    7 => -> { quit }
  }
  action = option_actions[option]
  if action
    action.call
  else
    puts 'Invalid option!'
  end
end

# Call the main method to execute the program
main
