

describe PlatformCategory do
  before :each do
    @platform_category = PlatformCategory.first
  end

  it "should be valid" do
    @platform_category.should be_valid
  end
end