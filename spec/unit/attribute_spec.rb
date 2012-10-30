

describe Attribute do

  before :each do
    @attribute = Attribute.first
  end

  it 'should be valid' do
    @attribute.should be_valid
  end

  it 'should be validate' do
    @attribute.is_validate(1).should be_true
  end

  it 'should return a correct data type' do
    @attribute.data_type.should eql(@attribute.attr_type)
  end

end
