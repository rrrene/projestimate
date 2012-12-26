require 'spec_helper'
describe EventsController do
  before :each do
    @event = Event.new(:id=>1,:name => 'Event1', :description => 'Event number 1', :start_date => nil, :end_date => nil, :event_type_id => nil, :project_id => nil)
  end
  describe "GET index" do
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end
  describe "New" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
  end

end