require 'logger'

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

      context "when configured to not raise an error" do
        it "doesn't raise an error for incompatible version" do
          with_loaded_gems('some_gem' => "1.0.1") do
            expect { |b| SanePatch.patch('some_gem', "0.0.1", raise_error: false, &b) }.to engage_guard_no_raise
          end
        end

        it "doesn't raise an error for incompatible version constraint" do
          with_loaded_gems('some_gem' => "1.0.1") do
            expect { |b| SanePatch.patch('some_gem', "~> 0.0.1", raise_error: false, &b) }.to engage_guard_no_raise
          end
        end

        it "doesn't raise an error for incompatible version constraints" do
          with_loaded_gems('some_gem' => "1.0.1") do
            expect { |b| SanePatch.patch('some_gem', ">= 0.0.1", "< 1.0.0", raise_error: false, &b) }.to engage_guard_no_raise
          end
        end
      end

      context "when configured with a logger" do
        let(:logger) { instance_double(Logger) }

        it "logs a warning for incompatible version" do
          with_loaded_gems('some_gem' => "1.0.1") do
            expect(logger).to receive(:warn).with(/some_gem/)
            SanePatch.patch('some_gem', "0.0.1", logger: logger, raise_error: false) { raise "Won't execute" }
          end
        end

        it "logs a warning for incompatible version constraint" do
          with_loaded_gems('some_gem' => "1.0.1") do
            expect(logger).to receive(:warn).with(/some_gem/)
            SanePatch.patch('some_gem', "0.0.1", logger: logger, raise_error: false) { raise "Won't execute" }
          end
        end

        it "logs a warning for incompatible version constraints" do
          with_loaded_gems('some_gem' => "1.0.1") do
            expect(logger).to receive(:warn).with(/some_gem/)
            SanePatch.patch('some_gem', "0.0.1", logger: logger, raise_error: false) { raise "Won't execute" }
          end
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
