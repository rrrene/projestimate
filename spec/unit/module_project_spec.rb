require "spec_helper"

describe ModuleProject do

  before :each do
    @project = Project.first
    @pemodule = Pemodule.new(:title => "Foo",
                            :alias => "foo",
                            :description => "Bar")
    @mp1 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 1)
    @mp2 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 1)
    @mp3 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 2)
    @mp3 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 2)
    @mp3 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 3)
    @mp4 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 3)
    @mp5 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 3)
  end

  it "should have a valid module" do
   @pemodule.should be_valid
  end

  it "should have a valid project" do
   @project.should be_valid
  end

  it "all pemodule should be valid" do
   @mp1.should be_valid
   @mp2.should be_valid
   @mp3.should be_valid
   @mp4.should be_valid
   @mp5.should be_valid
  end

  it "should return a project" do
    @mp1.project.should be_a_kind_of(Project)
    @mp2.project.should be_a_kind_of(Project)
    @mp3.project.should be_a_kind_of(Project)
    @mp4.project.should be_a_kind_of(Project)
    @mp5.project.should be_a_kind_of(Project)
  end

  it "should return next module project" do
    #pe_project = FactoryGirl.create(:project_first)
    #module_project1 = FactoryGirl.create(:module_project1)
    #module_project2 = FactoryGirl.create(:module_project2)
    #module_project1.next.should eql(module_project2)
  end



  #it "should return previous modules or nil if first modules" do
  #  @mp1.previous.should be_a(Array)
  #  @mp5.previous.should be_a(Array)
  #
  #  @mp1.previous.should be_empty
  #
  #  @mp5.previous.size.should eql(2)
  #  @mp3.previous.size.should eql(2)
  #  @mp5.previous.first.position_y.should eql(2)
  #end
  #
  #it "should verify if two modules in the same project are linked" do
  #
  #end
  #
  #it "should return the link" do
  #
  #end

end
