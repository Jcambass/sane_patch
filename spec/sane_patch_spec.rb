RSpec.describe SanePatch do
  let(:mock_gem_name) { "some_gem" }
  let(:mock_version) { nil }

  before do
    if mock_version
      allow(Gem.loaded_specs).to receive(:[]).with(mock_gem_name).and_return(
        double("Fake Gemspec", version: Gem::Version.new(mock_version))
      )
    end
  end

  describe "without gem loaded" do
    it "raises" do
      expect {
        SanePatch.patch(mock_gem_name, "2.5.0", details: "We need this cause.")
      }.to raise_error(ArgumentError).with_message("Can't patch unloaded gem #{mock_gem_name}")
    end
  end

  describe "with correct version loaded" do
    let(:mock_version) { "2.5.5" }

    it "executes block" do
      yielded = false
      SanePatch.patch(mock_gem_name, mock_version) do
        yielded = true
      end
      expect(yielded).to be true
    end
  end

  describe "with too recent version loaded" do
    let(:mock_version) { "2.5.5" }
    let(:required_version) { "2.0.0" }

    it "raises and does not execute block" do
      yielded = false

      expect {
        SanePatch.patch(mock_gem_name, required_version, details: "we need this") do
          yielded = true
        end
      }.to raise_error(RuntimeError).with_message(/It looks like the #{mock_gem_name} gem was upgraded.*we need this/m)

      expect(yielded).to be false
    end
  end
end
