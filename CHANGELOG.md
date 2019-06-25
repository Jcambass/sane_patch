# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2019-06-25
### Added
- Added test-suite covering existing functionality by [@PikachuEXE](https://github.com/PikachuEXE)
- Added the ability to specify more complex version constraints, we now support all constraints supported by [`RubyGems`](http://docs.seattlerb.org/rubygems/Gem/Requirement.html) thanks to the work of [@PikachuEXE](https://github.com/PikachuEXE) and [@jrochkind](https://github.com/jrochkind).

### Changed
- Fix Typo in code example used in README.
- Fix Typo in `gemspec` description.
- Use custom `SanePatch::Errors::GemAbsent` instead of `ArgumentError` when a unloaded gem is patched. `SanePatch::Errors::GemAbsent` inherits `ArgumentError`.
- Use custom `SanePatch::Errors::IncompatibleVersion` instead of `RuntimeError` when a loaded gem does not meet the requirements of a patch. For backwards compatibility reasons `SanePatch::Errors::IncompatibleVersion` inherits `RuntimeError`.

