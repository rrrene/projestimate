

describe Organization do
  before :each do
    @organization = Organization.first
  end

  it "should be valid" do
    @organization.should be_valid
  end
end