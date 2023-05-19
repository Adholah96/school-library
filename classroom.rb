class Classroom
    attr_accessor :label

    def initiallize(label)
        @label = label
        @students = []
    end

    def add_student(student)
        @students << student
        student.classrom = self
    end
end
