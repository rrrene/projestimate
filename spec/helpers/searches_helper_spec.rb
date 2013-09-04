require 'spec_helper'

describe SearchesHelper do

  before :each do
    @ksloc_attribute = FactoryGirl.create(:ksloc_attribute)
  end

  it "should display link" do
    display_link(@ksloc_attribute, "toto").should == "<a href=\"/pe_attributes/#{@ksloc_attribute.id}/edit\" class=\"search_result\" style=\"font-size:12px; color: #467aa7;\">Ksloc1 (ksloc1)</a>"
  end

  it "should display description" do
    display_description(@ksloc_attribute).should == "Attribut number 1"
  end

  it "should display last updated date" do
    display_update(@ksloc_attribute).should ==  "#{I18n.t(:text_latest_update)} #{I18n.l(@ksloc_attribute.updated_at)}"
  end

end
