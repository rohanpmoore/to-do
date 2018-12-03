class Task
  attr_reader(:description, :type)
  attr_accessor(:list_id)

  def initialize(attributes)
    @description = attributes.fetch(:description)
    @list_id = attributes.fetch(:list_id)
    @type = attributes.fetch(:type)
  end

  def self.all
    returned_tasks = DB.exec("SELECT * FROM tasks ORDER BY type;")
    tasks = []
    returned_tasks.each() do |task|
      description = task.fetch("description")
      list_id = task.fetch("list_id").to_i()
      type = task.fetch("type")
      tasks.push(Task.new({:description => description, :list_id => list_id, :type => type}))
    end
    tasks
  end

  def save(list_id = 1)
    @list_id = list_id
    DB.exec("INSERT INTO tasks (description, list_id, type) VALUES ('#{@description}', #{@list_id}, '#{@type}');")
  end

  def ==(another_task)
    self.description().==(another_task.description()).&(self.list_id().==(another_task.list_id())).&(self.type().==(another_task.type()))
  end
end
