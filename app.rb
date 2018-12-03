require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/task")
require("./lib/list")
require("pg")

DB = PG.connect({:dbname => "to_do"})

get("/") do
  erb(:index)
end

get("/lists/new") do
  erb(:list_form)
end

post("/lists") do
  name = params.fetch("name")
  list = List.new({:name => name, :id => nil})
  list.save
  erb(:list_success)
end

get('/lists') do
  @lists = List.all()
  erb(:lists)
end

get('/lists/:id') do
  id = params.fetch(:id).to_i
  @list = List.get_by_id(id)
  erb(:tasks)
end

post('/lists/:id') do
  id = params.fetch(:id).to_i
  @list = List.get_by_id(id)
  description = params.fetch("description")
  type = params.fetch("type")
  task = Task.new({:description => description, :type => type, :list_id => 1})
  @list.add_task(task)
  erb(:tasks)
end
