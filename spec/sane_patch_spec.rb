RSpec.describe SanePatch do
  it "has a version number" do
    expect(SanePatch::VERSION).not_to be nil
  end

  describe ".patch" do
    it "raises error for non-existing gem" do
      expect do
        ::SanePatch.patch("insame_patch", "0.0.1")
      end.to raise_error(::SanePatch::Errors::GemAbsent)
    end

    it "raises error for incompatible version" do
      expect do
        SanePatch.patch("rake", "0.0.1")
      end.to raise_error(::SanePatch::Errors::IncompatibleVersion)
    end
  end
end
