

describe ActivityCategory do
  before :each do
    @activity_category = ActivityCategory.first
  end

  it 'should be valid' do
    @activity_category.should be_valid
  end
end