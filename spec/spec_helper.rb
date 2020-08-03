require "bundler/setup"
require "sane_patch"
require 'rspec/expectations'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.include_chain_clauses_in_custom_matcher_descriptions = true
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

RSpec::Matchers.define :engage_guard do
  match do |actual|
    yielded = false
    expect {
      actual.call(Proc.new { yielded = true })
     }.to raise_error(SanePatch::Errors::IncompatibleVersion)
    expect(yielded).to be_falsey
  end

  match_when_negated do |actual|
    yielded = false
    actual.call(Proc.new { yielded = true })
    expect(yielded).to be_truthy
  end

  supports_block_expectations
end

RSpec::Matchers.define :engage_guard_no_raise do
  match do |actual|
    yielded = false
    expect {
      actual.call(Proc.new { yielded = true })
     }.to_not raise_error
    expect(yielded).to be_falsey
  end

  supports_block_expectations
end
