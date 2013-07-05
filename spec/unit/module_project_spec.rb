require "spec_helper"

describe ModuleProject do

  proposed_status = FactoryGirl.build(:proposed_status)
  before :each do
    @project = FactoryGirl.create(:project, :title => "M1project", :alias => "M1P", :state => "preliminary")

    @pemodule = Pemodule.new(:title => "Foo",
                            :alias => "foo",
                            :description => "Bar",
                            :uuid => "pepepe",
                            :record_status => proposed_status,
                            :compliant_component_type=>['Toto'])

    @mp1 = ModuleProject.create(:project_id => @project.id, :position_y => 1, :pemodule => @pemodule)
    @mp2 = ModuleProject.create(:project_id => @project.id, :position_y => 1, :pemodule => @pemodule)
    @mp3 = ModuleProject.create(:project_id => @project.id, :position_y => 3, :pemodule => @pemodule)
    @mp4 = ModuleProject.create(:project_id => @project.id, :position_y => 4, :pemodule => @pemodule)
    @mp5 = ModuleProject.create(:project_id => @project.id, :position_y => 5, :pemodule => @pemodule)
    @mp6 = ModuleProject.create(:project_id => @project.id, :position_y => 6, :pemodule => @pemodule)

    AssociatedModuleProject.create(:associated_module_project_id => @mp5.id, :module_project_id => @mp6.id)
    AssociatedModuleProject.create(:associated_module_project_id => @mp5.id, :module_project_id => @mp4.id)
    AssociatedModuleProject.create(:associated_module_project_id => @mp3.id, :module_project_id => @mp1.id)
    AssociatedModuleProject.create(:associated_module_project_id => @mp3.id, :module_project_id => @mp2.id)

    AssociatedModuleProject.create(:associated_module_project_id => @mp4.id, :module_project_id => @mp5.id)
    AssociatedModuleProject.create(:associated_module_project_id => @mp1.id, :module_project_id => @mp3.id)
    AssociatedModuleProject.create(:associated_module_project_id => @mp2.id, :module_project_id => @mp3.id)
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

  it "should have precedings" do
    @mp6.preceding.should include(@mp5)
  end

  #Don't modifie please: tests are in echec because methods next and previous are not fonctionnal'
  it "should return next module project" do
    @mp4.next().include?(@mp5).should be_true
  end
  it "should return previous module project" do
    @mp5.previous().include?(@mp4).should be_true
  end

  it "should not return next module project" do
    @mp5.next().include?(@mp4).should be_false
  end
  it "should not return previous module project" do
    @mp4.previous().include?(@mp5).should be_false
  end

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


  it "should return previous modules or nil if first modules" do
    #@mp5.associated_module_projects << @mp6

    @mp1.previous.should be_empty
    @mp5.previous.should_not be_empty    #be_a_kind_of

    @mp1.previous.should be_empty

    @mp5.previous.size.should eql(1)
    @mp3.previous.size.should eql(2)
    @mp5.previous.first.position_y.should eql(4)
  end


  #it "should be a One Activity-elements" do
  #  @one_elt_reference_value = FactoryGirl.create(:reference_value, :one_activity_elements)
  #  @one_elt_reference_value.value = "One Activity-element"
  #  @mp1.reference_value_id = @one_elt_reference_value.id
  #  @mp1.is_One_Activity_Element?.should be_true
  #end

  #TODO : will be transfer in ModuleProject class
  #it "should be an All Activity-elements" do
  #  all_activity_elt_ref_value = FactoryGirl.create(:reference_value, :all_activity_elements)
  #  all_activity_elt_ref_value.value = "All Activity-elements"
  #  @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => all_activity_elt_ref_value)
  #  @wbs_activity_ratio.is_All_Activity_Elements?.should be_true
  #end

  #TODO : will be transfer in ModuleProject class
  #it "should be a Set Of Activity-elements" do
  #  set_of_reference_value = FactoryGirl.create(:reference_value, :a_set_of_activity_elements)
  #  set_of_reference_value.value = "A set of activity-elements"
  #  @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => set_of_reference_value)
  #  @wbs_activity_ratio.is_A_Set_Of_Activity_Elements?.should be_true
  #end

  #Should be false
  #it "It's a set of activity-elements" do
  #  set_of_reference_value = FactoryGirl.create(:reference_value, :a_set_of_activity_elements)
  #  set_of_reference_value.value = "A set of activity-elements"
  #  @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => set_of_reference_value)
  #  @wbs_activity_ratio.is_One_Activity_Element?.should be_false
  #end

  #it "It's one of activity-element" do
  #  one_elt_reference_value = FactoryGirl.create(:reference_value, :one_activity_elements)
  #  one_elt_reference_value.value = "One Activity-element"
  #  @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => one_elt_reference_value)
  #  @wbs_activity_ratio.is_All_Activity_Elements?.should be_false
  #end

  #TODO : will be transfer in ModuleProject class
  #it "It's All of activity-elements" do
  #  all_activity_elt_ref_value = FactoryGirl.create(:reference_value, :all_activity_elements)
  #  all_activity_elt_ref_value.value = "All Activity-elements"
  #  @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => all_activity_elt_ref_value)
  #  @wbs_activity_ratio.is_A_Set_Of_Activity_Elements?.should be_false
  #end


  #Rescue
  #it "Rescue is_A_Set_Of_Activity_Elements " do
  #  @wbs_activity_ratio.is_A_Set_Of_Activity_Elements?.should be_false
  #end
  #
  #it "Rescue is_All_Activity_Elements" do
  #  @wbs_activity_ratio.is_All_Activity_Elements?.should be_false
  #end
  #
  #it "Rescue is_One_Activity_Element" do
  #  @wbs_activity_ratio.is_One_Activity_Element?.should be_false
  #end





  #
  #it "should verify if two modules in the same project are linked" do
  #
  #end
  #
  #it "should return false if two module of project aren't linked between them" do
  #  @mp1.is_linked_to?(@mp5, 1).should be_false
  #end
  #
  #it "should return true if two module of project are linked between them" do
  #  @mp1.is_linked_to?(@mp3, 1).should be_false
  #end

  #describe "Liaison" do
  #  before do
  #    @pe_wbs_project = FactoryGirl.create(:pe_wbs_project, :project => @project)
  #    @wet_link = FactoryGirl.create(:work_element_type, :wet_link)
  #    @attribute = FactoryGirl.create(:ksloc_attribute)
  #    @pbs_project_element = FactoryGirl.create(:pbs_project_element, :pe_wbs_project => @pe_wbs_project, :work_element_type => @wet_link)
  #    @estimation_value = FactoryGirl.create(:estimation_value, :module_project=> @mp1, :pbs_project_element => @pbs_project_element, :attribute => @attribute )
  #  end
  #
  #  it "should return the list of attributes that two modules of the project linked between them." do
  #    @mp1.liaison(nil, nil).should_not be_empty
  #  end
  #
  #  it "should return an empty array" do
  #    @mp2.liaison(nil, nil).should be_empty
  #  end
  #end
end
