require "spec_helper"

describe Language do

  before do
    #proposed_status = FactoryGirl.build(:record_status, :proposed)
    #@language = FactoryGirl.create(:language, record_status: proposed_status)
    @language = FactoryGirl.create(:fr_language)
    #@language2 = FactoryGirl.create(:language)
    @custom_status = FactoryGirl.build(:custom_status)
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

  it "should not be valid without uuid" do
    @language.uuid = ""
    @language.should_not be_valid
  end

  it "should not be valid without record_status" do
    @language.record_status = nil
    @language.should_not be_valid
  end

  it "should not be valid without custom_value when record_status='Custom'" do
    @language.record_status = @custom_status
    @language.should_not be_valid
  end


  it "should return :language name" do
    @language.to_s.should eql(@language.name)
  end

  #it "should duplicate language" do
  #  @language.record_status.id= @defined_status.id
  #  @language2=@language.amoeba_dup
  #  @language2.record_status.name.should eql("Proposed")
  #  @language2.reference_id = @language.id
  #  @language2.reference_uuid = @language.uuid
  #end

end
