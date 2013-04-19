require 'spec_helper'

describe SearchesHelper do

  before :each do
    @ksloc_attribute = FactoryGirl.create(:ksloc_attribute)
  end

  it "should display description" do
    display_link(@ksloc_attribute, "toto").should == "<a href=\"/pe_attributes/#{@ksloc_attribute.id}/edit\" class=\"search_result\">Ksloc1 - Attribut number 1</a>"
  end

  it "should display description" do
    display_description(@ksloc_attribute).should == "Attribut number 1"
  end

  it "should display description" do
    display_update(@ksloc_attribute).should == "Last update #{@ksloc_attribute.updated_at.strftime("%d %m %Y")}"
  end

end
