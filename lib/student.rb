require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_stu = Student.new
    new_stu.id = row[0]
    new_stu.name = row[1]
    new_stu.grade = row[2]
    new_stu
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    stu_arr = DB[:conn].execute(sql)

    stu_arr.map do |student|
      Student.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.name = ?
    SQL
    stu_arr = DB[:conn].execute(sql, name).flatten
    Student.new_from_db(stu_arr)
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
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    Student.all_students_in_grade_X(9)
  end

  def self.all_students_in_grade_X(grade)
    Student.all.select do |student|
      student.grade == grade
    end
  end

  def self.first_student_in_grade_10
    Student.all_students_in_grade_X(10).first
  end

  def self.students_below_12th_grade
    Student.all.select do |student|
      student.grade < 12
    end
  end

  def self.first_X_students_in_grade_10(num)
    Student.all.select do |student|
      student.grade == 10
    end[0..num-1]
  end
end
