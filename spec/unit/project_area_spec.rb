

describe ProjectArea do
  before :each do
    @project_area = ProjectArea.first
  end

  it "should be valid" do
    @project_area.should be_valid
  end
end