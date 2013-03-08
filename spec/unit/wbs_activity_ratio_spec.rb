require 'spec_helper'

describe WbsActivityRatio do

  before :each do
    @wbs_activity = FactoryGirl.create(:wbs_activity)
    @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity)
  end

  it "should be valid" do
    @wbs_activity_ratio.should be_valid
  end

  it "should not be valid without name" do
    @wbs_activity_ratio.name = ""
    @wbs_activity_ratio.should_not be_valid
  end

  it "should not be valid without uuid" do
    @wbs_activity_ratio.uuid = ""
    @wbs_activity_ratio.should_not be_valid
  end

  it "should not be valid without custom_value when record_status = Custom" do
    @custom_status = FactoryGirl.build(:custom_status)
    @wbs_activity_ratio.record_status = @custom_status
    @wbs_activity_ratio.custom_value = ""
    @wbs_activity_ratio.should_not be_valid
  end

  it "should not be valid, when name already exist in same wbs-activity" do
    wbs_activity_ratio_2 = @wbs_activity_ratio.dup
    wbs_activity_ratio_2.name = @wbs_activity_ratio.name
    wbs_activity_ratio_2.save
    wbs_activity_ratio_2.should_not be_valid
  end

  it "should be a One Activity-elements" do
    one_elt_reference_value = FactoryGirl.create(:reference_value, :one_activity_elements)
    one_elt_reference_value.value = "One Activity-element"
    @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => one_elt_reference_value)
    @wbs_activity_ratio.is_One_Activity_Element?.should be_true
  end

  it "should be an All Activity-elements" do
    all_activity_elt_ref_value = FactoryGirl.create(:reference_value, :all_activity_elements)
    all_activity_elt_ref_value.value = "All Activity-elements"
    @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => all_activity_elt_ref_value)
    @wbs_activity_ratio.is_All_Activity_Elements?.should be_true
  end

  it "should be a Set Of Activity-elements" do
    set_of_reference_value = FactoryGirl.create(:reference_value, :a_set_of_activity_elements)
    set_of_reference_value.value = "A set of activity-elements"
    @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => set_of_reference_value)
    @wbs_activity_ratio.is_A_Set_Of_Activity_Elements?.should be_true
  end

  #Should be false
  it "It's a set of activity-elements" do
    set_of_reference_value = FactoryGirl.create(:reference_value, :a_set_of_activity_elements)
    set_of_reference_value.value = "A set of activity-elements"
    @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => set_of_reference_value)
    @wbs_activity_ratio.is_One_Activity_Element?.should be_false
  end

  it "It's one of activity-element" do
    one_elt_reference_value = FactoryGirl.create(:reference_value, :one_activity_elements)
    one_elt_reference_value.value = "One Activity-element"
    @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => one_elt_reference_value)
    @wbs_activity_ratio.is_All_Activity_Elements?.should be_false
  end

  it "It's All of activity-elements" do
    all_activity_elt_ref_value = FactoryGirl.create(:reference_value, :all_activity_elements)
    all_activity_elt_ref_value.value = "All Activity-elements"
    @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio, :wbs_activity => @wbs_activity, :reference_value => all_activity_elt_ref_value)
    @wbs_activity_ratio.is_A_Set_Of_Activity_Elements?.should be_false
  end


  #Rescue
  it "Rescue is_A_Set_Of_Activity_Elements " do
    @wbs_activity_ratio.is_A_Set_Of_Activity_Elements?.should be_false
  end

  it "Rescue is_All_Activity_Elements" do
    @wbs_activity_ratio.is_All_Activity_Elements?.should be_false
  end

  it "Rescue is_One_Activity_Element" do
    @wbs_activity_ratio.is_One_Activity_Element?.should be_false
  end

end
