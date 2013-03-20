require "spec_helper"
describe RecordStatus do
  before :each do
    @RecordStatus=  FactoryGirl.create(:proposed_status)
  end
  #
  it 'should return record_status name' do
    @RecordStatus.to_s().should eql( @RecordStatus.name)
  end
  #it "should be not valid" do
  #  @RecordStatus.name= 1
  #  @RecordStatus.wbs_activity_name.should_not be_instance_of(String)
  #end
  #
  #it "should be valid" do
  #  @RecordStatus.wbs_activity_name.should be_an_instance_of(String)
  #end



end