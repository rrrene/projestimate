require "spec_helper"
describe AcquisitionCategory do
  before :each do
    @acquisition_category = FactoryGirl.create(:acquisition_category, :unknown, :name => "ac_new_name")
  end

  it 'should be valid' do
    @acquisition_category.should be_valid
  end

  it "should be not valid without :name" do
    @acquisition_category.name = ""
    @acquisition_category.should_not be_valid
  end

  it "should be not valid without :description" do
    @acquisition_category.description = ""
    @acquisition_category.should_not be_valid
  end

  it "should be not valid without UUID" do
    @acquisition_category.uuid = ""
    @acquisition_category.should_not be_valid
  end

  it "should be not valid without record status" do
    @acquisition_category.record_status = nil
    @acquisition_category.should_not be_valid
  end

  specify "should return :acquisition_category name" do
    @acquisition_category.to_s.should eql(@acquisition_category.name)
  end
end