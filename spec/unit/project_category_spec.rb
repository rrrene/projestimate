

describe ProjectCategory do
  before :each do
    @project_category = ProjectCategory.first
  end

  it "should be valid" do
    @project_category.should be_valid
  end
end