require('spec_helper')

describe(List) do
  describe(".all") do
    it("starts off with no lists") do
      expect(List.all()).to(eq([]))
    end
  end

  describe("#name") do
    it("tells you its name") do
      list = List.new({:name => "Epicodus stuff", :id => nil})
      expect(list.name()).to(eq("Epicodus stuff"))
    end
  end

  describe("#id") do
    it("sets its ID when you save it") do
      list = List.new({:name => "Epicodus stuff", :id => nil})
      list.save
      expect(list.id()).to(be_an_instance_of(Integer))
    end
  end

  describe("#add_task") do

  end

  describe("#save") do
    it("lets you save lists to the database") do
      list = List.new({:name => "Epicodus stuff", :id => nil})
      list.save
      expect(List.all()).to(eq([list]))
    end
    it("lets you save lists with associated tasks") do
      list = List.new({:name => "Epicodus stuff", :id => nil})
      list.save
      task1 = Task.new({:description => "learn SQL", :list_id => list.id, :type => "morning"})
      task2 = Task.new({:description => "go home", :list_id => list.id, :type => "evening"})
      list.add_task(task1)
      list.add_task(task2)
      expect(List.all()).to(eq([list]))
    end
  end

  describe("#==") do
    it("is the same list if it has the same name") do
      list1 = List.new({:name => "Epicodus stuff", :id => nil})
      list2 = List.new({:name => "Epicodus stuff", :id => nil})
      list1.save
      list2.save
      task1 = Task.new({:description => "learn SQL", :list_id => list1.id, :type => "morning"})
      task2 = Task.new({:description => "go home", :list_id => list1.id, :type => "evening"})
      list1.add_task(task1)
      list1.add_task(task2)
      list2.add_task(task1)
      list2.add_task(task2)
      expect(list1).to(eq(list2))
    end
  end
end
