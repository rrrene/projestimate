

describe WorkElementType do

  before :each do
    @work_element_type = WorkElementType.new
  end

  it 'should be not valid' do
    @work_element_type.should_not be_valid
  end

end