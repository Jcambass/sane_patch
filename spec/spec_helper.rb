require "bundler/setup"
require "sane_patch"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def with_loaded_gems(gem_name_version_hash)
  gem_name_version_hash.each_pair do |gem_name, gem_version|
    allow(Gem.loaded_specs).to receive(:[]).with(gem_name).and_return(
      double("Fake Gemspec for #{gem_name}", version: Gem::Version.new(gem_version))
    )
  end

  yield
end
