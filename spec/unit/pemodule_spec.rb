

describe Pemodule do
  before :each do
    @pemodule = Pemodule.first
  end

  it "should be valid" do
    @pemodule.should be_valid
  end
end