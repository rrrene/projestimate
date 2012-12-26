require "spec_helper"

  describe Peicon do

    before :each do
      @peicon = FactoryGirl.create(:peicon_folder)
    end

    it "should be valid" do
      @peicon.should be_valid
    end

    it "should not be valid without :icon_file_name" do
      @peicon.icon_file_name = ""
      @peicon.should_not be_valid
    end

    it "should validate icon content type (image/png)" do
      @peicon.icon_content_type.should eql("image/png")
    end

    it "should validate image icon size (0..10.kilobytes)" do
      @peicon.icon_file_size.should be_between(0, 10.kilobytes)
    end
  end