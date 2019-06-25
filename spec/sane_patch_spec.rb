RSpec.describe SanePatch do
  it "has a version number" do
    expect(SanePatch::VERSION).not_to be nil
  end

  describe ".patch" do
    context "when gem is not installed" do
      it "raises error for non-existing gem" do
        expect do
          SanePatch.patch('some_gem', "0.0.1")
        end.to raise_error(SanePatch::Errors::GemAbsent)
      end
    end

    context "when gem is installed", :aggregate_failures do
      it "raises error for incompatible version" do
        with_loaded_gems('some_gem' => "1.0.1") do
          expect { |b| SanePatch.patch('some_gem', "0.0.1", &b) }.to engage_guard
        end
      end

      it "raises error for incompatible version constraint" do
        with_loaded_gems('some_gem' => "1.0.1") do
          expect { |b| SanePatch.patch('some_gem', "~> 0.0.1", &b) }.to engage_guard
        end
      end

      it "raises error for incompatible version constraints" do
        with_loaded_gems('some_gem' => "1.0.1") do
          expect { |b| SanePatch.patch('some_gem', ">= 0.0.1", "< 1.0.0", &b) }.to engage_guard
        end
      end

      it "execute block for compatible version" do
        with_loaded_gems('some_gem' => "1.0.1") do
          expect { |b| SanePatch.patch('some_gem', "1.0.1", &b) }.not_to engage_guard
        end
      end

      it "execute block for compatible version constraint" do
        with_loaded_gems('some_gem' => "1.0.1") do
          expect { |b| SanePatch.patch('some_gem', "~> 1.0.0", &b) }.not_to engage_guard
        end
      end

      it "execute block for compatible version constraints" do
        with_loaded_gems('some_gem' => "1.0.1") do
          expect { |b| SanePatch.patch('some_gem', ">= 1.0.0", "< 1.1.0", &b) }.not_to engage_guard
        end
      end
    end
  end
end
