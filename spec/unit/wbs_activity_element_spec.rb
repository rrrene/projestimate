require "spec_helper"

describe WbsActivityElement do

  before :each do
    @wbs_activity_element = FactoryGirl.create(:wbs_activity_element)
    @wbs_activity_element2 = FactoryGirl.create(:wbs_activity_element, :name=>1)
  end

  it 'should return wbs_activity name' do
    @wbs_activity_element.wbs_activity_name.should eql(@wbs_activity_element.wbs_activity.name)
  end

  it "should be not valid without wbs-activity" do
    @wbs_activity_element2.wbs_activity.should_not be_nil
  end

  it "should be valid" do
    @wbs_activity_element.should be_valid
  end

end