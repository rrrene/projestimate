

describe Language do

  before :each do
    @language = Language.first
  end

  it 'should be valid' do
    @language.should be_valid
  end

end
