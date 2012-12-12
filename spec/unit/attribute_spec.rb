require "spec_helper"

describe Attribute do

  before :each do
    @attribute = Attribute.first
  end

  # Attrbutes validations

  #it 'should validate value' do
  #  @attribute.is_validate(15).should be_true
  #end
  #
  #it 'should validate value' do
  #  @attribute.is_validate(9).should be_false
  #end
  #
  #it 'should validate value' do
  #  @attribute.is_validate("toto").should be_false
  #end

  it 'should be valid' do
    @attribute.should be_valid
  end

  it 'should be validate' do
    @attribute.is_validate(1).should be_true
  end

  it "should be not valid without name" do
    @attribute.name = ""
    @attribute.should_not be_valid
  end

  it "should be not valid without description" do
    @attribute.description = ""
    @attribute.should_not be_valid
  end

  it "should be not valid without alias" do
    @attribute.alias = ""
    @attribute.should_not be_valid
  end

  it "should be not valid without attribute type :attr_type" do
    @attribute.attr_type = nil
    @attribute.should_not be_valid
  end

  it 'should return a correct data type' do
    @attribute.data_type.should eql(@attribute.attr_type)
  end

  specify "should return :name + ' - ' + :description.truncate(20)" do
    @attribute.to_s.should eql(@attribute.name + ' - ' + @attribute.description.truncate(20) )
  end


  # Others method

  #it "should return the attribute type" do
  #  attribute = FactoryGirl.create(:ksloc_attribute)
  #  attribute.data_type.should eql(attribute.attr_type)
  #end

  #TODO
  #it "should be validate" do
  #  attribute = FactoryGirl.create(:ksloc_attribute)
  #end
end
