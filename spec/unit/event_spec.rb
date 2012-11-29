require "spec_helper"

describe Event do
  before :each do
    @event = Event.new(:name => 'Event1', :description => 'Event number 1', :start_date => nil, :end_date => nil, :event_type_id => nil, :project_id => nil)
  end

  it "should be valid" do
    @event.should be_valid
  end

  describe "when the event name is not set" do
    it "should be not valid without name attribute" do
      @event.name=""
      @event.should_not be_valid
    end
  end

end