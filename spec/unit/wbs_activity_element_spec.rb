require "spec_helper"
describe WbsActivityElement do
  before :each do
    @WbsActivity=  FactoryGirl.create(:wbs_activity)
    @WbsActivityElement = FactoryGirl.create(:wbs_activity_element,:wbs_activity_id=>@WbsActivity.id)
    @WbsActivityElement2 = FactoryGirl.create(:wbs_activity_element,:wbs_activity_id=>@WbsActivity.id, :name=>1)

  end

  it 'should return wbs_activity name' do
    @WbsActivityElement.wbs_activity_name.should eql(@WbsActivityElement.name)
  end
  it "should be not valid" do
    @WbsActivityElement2.wbs_activity_name.should_not be_instance_of(String)
  end

  it "should be valid" do
    @WbsActivityElement.wbs_activity_name.should be_an_instance_of(String)
  end



end