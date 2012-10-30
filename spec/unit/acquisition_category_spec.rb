describe AcquisitionCategory do
  before :each do
    @acquisition_category = AcquisitionCategory.first
  end

  it 'should be valid' do
    @acquisition_category.should be_valid
  end
end