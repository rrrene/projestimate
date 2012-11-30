require "spec_helper"

describe Pemodule do
  before :each do
    #@pemodule = Pemodule.first
    @pemodule = Pemodule.new(:title => "CocomoBasic", :alias => "cocomo_basic", :description => "CocomoBasic vraiment basic")
  end

  it "should be valid" do
    @pemodule.should be_valid
  end

  it "should be display title" do
    @pemodule.to_s.should eql(@pemodule.title)
  end

  it "should not be valid without title" do
    @pemodule.title = ""
    @pemodule.should_not be_valid
  end

  it "should not be valid without alias" do
    @pemodule.alias = ""
    @pemodule.should_not be_valid
  end

  it "should not be valid without description" do
    @pemodule.description = ""
    @pemodule.should_not be_valid
  end

  it "should return module title " do
    @pemodule.to_s.should eql(@pemodule.title)
  end

end