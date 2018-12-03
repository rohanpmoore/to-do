class List
  attr_reader(:name, :id, :tasks)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @tasks = []
  end

  def self.all
    returned_lists = DB.exec("SELECT * FROM lists;")
    lists = []
    returned_lists.each() do |list|
      name = list.fetch("name")
      id = list.fetch("id").to_i()
      lists.push(List.new({:name => name, :id => id}))
      returned_tasks = DB.exec("SELECT * FROM tasks WHERE list_id = #{id}")
      returned_tasks.each do |task|
        description = task.fetch("description")
        list_id = task.fetch("list_id").to_i()
        type = task.fetch("type")
        task = Task.new({:description => description, :list_id => list_id, :type => type})
        lists[-1].tasks.push(task)
      end
    end
    lists
  end

  def save
    result = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
    # @tasks.each do |task|
    #   DB.exec("INSERT INTO tasks (description, list_id, type) VALUES ('#{task.description}', #{@id}, '#{task.type}');")
    #   task.list_id = result.first().fetch("id").to_i
    # end
  end

  def ==(another_list)
    if !(self.name().==(another_list.name()))
      return false
    end
    tasks_one = self.tasks
    tasks_two = another_list.tasks
    if(tasks_one.length != tasks_two.length)
      return false
    end
    index = 0
    while index < tasks_one.length
      if(!(tasks_one[index].==tasks_two[index]))
        return false
      end
      index += 1
    end
    true
  end

  def self.get_by_id(id)
    lists = List.all
    lists.each do |list|
      if list.id == id
        return list
      end
    end
  end

  def add_task(task)
    @tasks.push(task)
    task.save(@id)
  end
end
