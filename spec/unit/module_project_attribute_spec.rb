require "spec_helper"

describe ModuleProjectAttribute do

  before :each do
    @project = Project.first
    @pemodule = Pemodule.new(:title => "Foo",
                            :alias => "foo",
                            :description => "Bar")
    @module_project = ModuleProject.new(:project_id => @project.id, :pemodule_id => @pemodule.id, :position_y => 1)

    @mpa = ModuleProjectAttribute.new(:attribute_id => nil,
                                      :in_out => "input",
                                      :module_project_id => @module_project.id,
                                      :custom_attribute => "user",
                                      :is_mandatory => true,
                                      :description => "Undefined",
                                      :undefined_attribute => true,
                                      :dimensions => 3)
  end

  it "should return custom attribute or not " do
    @mpa.custom_attribute?.should be_true
  end

  #it "should be not valid" do
  #  @mpa.attribute.name=1
  #  @mpa.to_s.should_not be_instance_of(String)
  #end
  #
  #it "should be valid" do
  #  @mpa.to_s.should be_an_instance_of(String)
  #end

  #it "should return module project attribute name" do
  #  @mpa.to_s.should eql(@mpa.attribute.name)
  #end
end
