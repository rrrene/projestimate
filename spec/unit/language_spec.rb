require "spec_helper"

describe Language do

  before :each do
    @language = Language.first
  end

  it 'should be valid' do
    @language.should be_valid
  end

  it "should not be valid without :name" do
    @language.name = ""
    @language.should_not be_valid
  end

  it "should not be valid without :locale" do
    @language.locale = ""
    @language.should_not be_valid
  end

  it "should return :language name" do
    @language.to_s.should eql(@language.name)
  end

end
