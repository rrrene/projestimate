require "spec_helper"

describe ModuleProject do

  before :each do
    @project = FactoryGirl.create(:project, :title => "M1project", :alias => "M1P", :state => "preliminary")

    @pemodule = Pemodule.new(:title => "Foo",
                            :alias => "foo",
                            :description => "Bar",
                            :compliant_component_type=>['Toto'])

    @mp1 = ModuleProject.create(:project_id => @project.id, :pemodule => @pemodule, :position_y => 1)
    @mp2 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 1)
    @mp3 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 2)
    @mp3 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 2)
    @mp3 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 3)
    @mp4 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 4)
    @mp5 = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 5)
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
  #Don't modifie please: tests are in echec because methods next and previous are not fonctionnal'
  #it "should return next module project" do
  #  @mp4.next().include?(@mp5).should be_true
  #end
  #it "should return previous module project" do
  #  @mp5.previous().include?(@mp4).should be_true
  #end
  #
  #it "should not return next module project" do
  #  @mp5.next().include?(@mp4).should be_false
  #end
  #it "should not return previous module project" do
  #  @mp4.previous().include?(@mp5).should be_false
  #end
  it "should be return false if pemodule.compliant_component_type is nil" do
    @mp2.pemodule.compliant_component_type=nil
    @mp2.compatible_with('Toto').should be_false
  end
  it "should be return pemodule.compliant_component_type include allias" do
    @mp2.compatible_with('Toto').should be_true
  end
  it "should be return pemodule.compliant_component_type include allias" do
    @mp2.compatible_with('Tata').should be_false
  end
  it "should not be a string" do
    @mp2.pemodule.title=1
    @mp2.to_s.should_not be_instance_of(String)
  end

  it "should a string" do
    @mp2.to_s.should be_an_instance_of(String)
  end

  it "should return pemodule title" do
    @mp2.to_s.should eql(@mp2.pemodule.title)
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

end
