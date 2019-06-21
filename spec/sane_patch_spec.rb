RSpec.describe SanePatch do
  it "has a version number" do
    expect(SanePatch::VERSION).not_to be nil
  end

  describe ".patch" do
    let(:gem_name) { "some_gem" }

    context "when gem is not installed" do
      it "raises error for non-existing gem" do
        expect do
          ::SanePatch.patch(gem_name, "0.0.1")
        end.to raise_error(::SanePatch::Errors::GemAbsent)
      end
    end

    context "when gem is installed", :aggregate_failures do
      it "raises error for incompatible version" do
        yielded = false

        with_loaded_gems(gem_name => "1.0.1") do
          expect do
            SanePatch.patch(gem_name, "0.0.1") do
              yielded = true
            end
          end.to raise_error(::SanePatch::Errors::IncompatibleVersion)
          expect(yielded).to be_falsey
        end
      end

      it "raises error for incompatible version constraint" do
        yielded = false

        with_loaded_gems(gem_name => "1.0.1") do
          expect do
            SanePatch.patch(gem_name, "~> 0.0.1") do
              yielded = true
            end
          end.to raise_error(::SanePatch::Errors::IncompatibleVersion)
          expect(yielded).to be_falsey
        end
      end

      it "raises error for incompatible version constraints" do
        yielded = false

        with_loaded_gems(gem_name => "1.0.1") do
          expect do
            SanePatch.patch(gem_name, ">= 0.0.1", "< 1.0.0") do
              yielded = true
            end
          end.to raise_error(::SanePatch::Errors::IncompatibleVersion)
          expect(yielded).to be_falsey
        end
      end


      it "execute block for compatible version" do
        yielded = false

        with_loaded_gems(gem_name => "1.0.1") do
          expect do
            SanePatch.patch(gem_name, "1.0.1") do
              yielded = true
            end
          end.to_not raise_error
          expect(yielded).to be_truthy
        end
      end

      it "execute block for compatible version constraint" do
        yielded = false

        with_loaded_gems(gem_name => "1.0.1") do
          expect do
            SanePatch.patch(gem_name, "~> 1.0.0") do
              yielded = true
            end
          end.to_not raise_error
          expect(yielded).to be_truthy
        end
      end

      it "execute block for compatible version constraints" do
        yielded = false

        with_loaded_gems(gem_name => "1.0.1") do
          expect do
            SanePatch.patch(gem_name, ">= 1.0.0", "< 1.1.0") do
              yielded = true
            end
          end.to_not raise_error
          expect(yielded).to be_truthy
        end
      end
    end
  end
end
