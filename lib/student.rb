require 'pry'
class Student
  attr_accessor :id, :name, :grade

  # no need for def initialize

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    # binding.pry
    return student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    # binding.pry
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)
    # binding.pry
    Student.new_from_db(row.flatten)
  end

  def self.all
    # binding.pry
    DB[:conn].execute("SELECT * FROM students").map do |row|
      new_from_db(row)
    end
  end

  def self.all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9").map do |row|
      new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    # binding.pry
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12").map do |row|
      new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(num)
    # binding.pry
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 ORDER BY id ASC LIMIT #{num}").map do |row|
      new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    # binding.pry
    a = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 ORDER BY students.id ASC LIMIT 1")
    new_from_db(a.flatten)
    # binding.pry
  end

  def self.all_students_in_grade_X(num)
    # binding.pry
    DB[:conn].execute("SELECT * FROM students WHERE grade = #{num}").map do |row|
      new_from_db(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
