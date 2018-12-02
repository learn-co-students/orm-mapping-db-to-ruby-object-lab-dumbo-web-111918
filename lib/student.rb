require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    # row creates an array of the info
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
    #don't forget to end with student!
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    #write the SQL query to get the rows
    sql = <<-SQL
    SELECT *
    FROM STUDENTS
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    # this is same code as above except query is where by name
    # pass in name to execute as well and get only the first instance of
    # map array
     sql = <<-SQL
    SELECT *
    FROM STUDENTS
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  # def self.all_students_in_grade_9
  #   self.all.select do |student|
  #     student.grade == "9"
  #   end
  # end

  #with SQL query
  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM STUDENTS
    WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end


  # def self.students_below_12th_grade
  #   self.all.select do |student|
  #     student.grade != "12"
  #   end
  # end
   def self.students_below_12th_grade
     sql = <<-SQL
    SELECT *
    FROM STUDENTS
    WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end


  # def self.first_X_students_in_grade_10(num)
  #   #binding.pry
  #   self.all.select do |student|
  #     student.grade == "10"
  #   end.slice(0,(num))
  # end
  def self.first_X_students_in_grade_10(num)
     sql = <<-SQL
    SELECT *
    FROM STUDENTS
    WHERE grade = 10
    ORDER BY students.id
    LIMIT ?
    SQL

    DB[:conn].execute(sql, num).map do |row|
      self.new_from_db(row)
    end
  end

   def self.first_student_in_grade_10
     sql = <<-SQL
    SELECT *
    FROM STUDENTS
    WHERE grade = 10
    LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(num)
    sql = <<-SQL
    SELECT *
    FROM STUDENTS
    WHERE grade = ?
    SQL

    DB[:conn].execute(sql, num).map do |row|
      self.new_from_db(row)
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
