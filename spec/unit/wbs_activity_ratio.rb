require 'spec_helper'

describe WbsActivityRatio do

  before :each do
    @reference_value_All =  FactoryGirl.create(:all_activity_elements)
    @wbs_activity_ratio_All = FactoryGirl.create(:wbs_activity_ratio,:reference_value => @reference_value_All)
    @reference_value_Set =  FactoryGirl.create(:reference_value, :set)
    @wbs_activity_ratio_Set = FactoryGirl.create(:wbs_activity_ratio, :reference_value => @reference_value_Set)
    @reference_value_One =  FactoryGirl.create(:reference_value, :one)
    @wbs_activity_ratio_One = FactoryGirl.create(:wbs_activity_ratio, :reference_value => @reference_value_One)
    @wbs_activity_ratio = FactoryGirl.create(:wbs_activity_ratio)

  end

  #Should be true
  it "It's a set of activity-elements" do
    @wbs_activity_ratio_Set.is_A_Set_Of_Activity_Elements?.should be_true
  end

  it "It's one of activity-element" do
    @wbs_activity_ratio_One.is_One_Activity_Element?.should be_true
  end

  it "It's All of activity-elements" do
    @wbs_activity_ratio_All.is_All_Activity_Elements?.should be_true
  end

  #Should be false
  it "It's a set of activity-elements" do
    @wbs_activity_ratio_Set.is_One_Activity_Element?.should be_false
  end

  it "It's one of activity-element" do
    @wbs_activity_ratio_One.is_All_Activity_Elements?.should be_false
  end

  it "It's All of activity-elements" do
    @wbs_activity_ratio_All.is_A_Set_Of_Activity_Elements?.should be_false
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
