require_relative "Employee"
class Manager < Employee
  attr_reader :subordinates
  def initialize(name, title, salary, boss, subordinates)
    super(name, title, salary, boss)
    @subordinates = subordinates
  end

  def bonus(multiplier)
    all_subordinates = get_subordinates
    all_salaries = 0
    all_subordinates.each do |sub|
      all_salaries += sub.salary
    end
    all_salaries * multiplier
  end

  def get_subordinates
    all_subordinates = []
    queue = [self]
    until queue.empty?
      current = queue.shift
      if current.is_a?(Manager)
        all_subordinates += current.subordinates
        queue += current.subordinates
      end
    end
    all_subordinates - [self]
  end
end

shawna = Employee.new("Shawna", "TA", 12000, "darren")
david = Employee.new("David", "TA", 10000, "darren")

darren = Manager.new("Darren", "TA Manager", 78000, "ned", [shawna,david] )

ned = Manager.new("Ned", "Founder", 1000000, nil, [darren] )
# ned.get_subordinates.each {|sub| p sub.name}

p darren.bonus(2)
