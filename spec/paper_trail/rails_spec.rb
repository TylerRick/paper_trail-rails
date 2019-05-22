RSpec.describe PaperTrail::Rails do
  it "has a version number" do
    expect(PaperTrail::Rails.version).to be_present
  end

  describe 'rails console' do
    it "asks for user"
    it "records command"
  end

  describe 'migrations' do
    it "records migration name"
  end
end
