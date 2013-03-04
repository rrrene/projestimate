require 'spec_helper'

describe ReferenceValue do

  before :each do
    @reference_value = FactoryGirl.create(:reference_value, :a_set_of_activity_elements)
  end

  it "should be valid" do
    @reference_value.should be_valid
  end

  it "should not be valid without value" do
    @reference_value.value = ""
    @reference_value.should_not be_valid
  end

  it "should not be valid when value exist with same record status" do
    reference_value_2 = @reference_value.dup
    reference_value_2.value = @reference_value.value
    reference_value_2.save
    reference_value_2.should_not be_valid
  end

end
