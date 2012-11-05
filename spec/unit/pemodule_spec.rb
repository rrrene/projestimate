require "spec_helper"

describe Pemodule do
  before :each do
    @pemodule = Pemodule.first
  end

  it "should be valid" do
    @pemodule.should be_valid
  end

  it "should be display title" do
    @pemodule.to_s.should eql(@pemodule.title)
  end
end