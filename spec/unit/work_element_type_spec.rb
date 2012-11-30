require "spec_helper"

describe WorkElementType do

  before :each do
    @work_element_type = WorkElementType.new
  end

  it 'should be not valid' do
    @work_element_type.should_not be_valid
  end

  it "should not be valid without name" do
    @work_element_type.name = ""
    @work_element_type.should_not be_valid
  end

  it "should not be valid without alias" do
    @work_element_type.alias = ""
    @work_element_type.should_not be_valid
  end

  it "should return work element type name" do
    @work_element_type.to_s.should eql(@work_element_type.name)
  end

end