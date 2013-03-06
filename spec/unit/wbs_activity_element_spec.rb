require "spec_helper"

describe WbsActivityElement do

  before :each do
    @wbs_activity=  FactoryGirl.create(:wbs_activity)
    @wbs_activity_element = FactoryGirl.create(:wbs_activity_element)
    @wbs_activity_element2 = FactoryGirl.create(:wbs_activity_element, :name=>1)
  end

  it 'should return wbs_activity name' do
    @wbs_activity_element.wbs_activity = @wbs_activity
    @wbs_activity_element.wbs_activity_name.should eql(@wbs_activity.name)
  end

  it "should be not valid" do
    @wbs_activity_element2.wbs_activity_name.should_not be_instance_of(String)
  end

  it "should be valid" do
    @wbs_activity_element.should be_valid
  end

end