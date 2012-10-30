

describe Permission do

  before :each do
    @permission = Permission.first
  end

  it "should be valid" do
    @permission.should be_valid
  end
end