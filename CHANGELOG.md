# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.1.4] - 2026-10-03

### Fixed
- Array element access uses `$data[n]` instead of `@data[n]`, and `use warnings` is enabled.

## [0.1.3] - 2026-10-03

### Fixed
- Usage is printed with exit status 1 when no arguments, invalid options, or `-i` without `-c` are given.

## [0.1.2] - 2026-10-03

### Fixed
- Version is read in Perl rather than by shelling out to `cat | grep | awk`.

## [0.1.1] - 2026-10-03

### Fixed
- Empty rows are skipped instead of producing blank-hostname warnings.

## [0.1.0] - 2026-10-03

### Fixed
- Environment check (Dev / Prod / Test) matches whole words in the name, description, location and domain fields instead of anywhere in the row.

## [0.0.9] - 2026-10-03

### Fixed
- Missing input file now exits with status 1 and reports to stderr.

## [0.0.8] - 2026-10-03

### Fixed
- OS name check no longer accepts punctuation such as `_` (`[A-z]` replaced with `[A-Za-z]`).

## [0.0.7] - 2026-10-03

### Fixed
- All worksheets are processed, not just the first.

## [0.0.6] - 2026-10-03

### Fixed
- Commas inside cells no longer shift columns; rows are kept as arrays instead of comma-joined strings.

## [0.0.5] - 2026-10-03

### Added
- Automatic installation of missing Perl modules into `~/perl5`.
- `cpanfile` listing the required modules.
- `LICENSE` file containing the CC BY-NC-SA 4.0 legal code.
- "Help Support Development" section in the README.

### Changed
- License changed from CC-BA to CC BY-NC-SA.
- Changelog converted to `CHANGELOG.md` in Keep a Changelog format.

## [0.0.4] - 2014-06-17

### Changed
- Updated documentation and license.

## [0.0.3] - 2013-10-01

### Added
- `-i` switch to choose the input file.

## [0.0.2] - 2013-10-01

### Changed
- Cleaned up output messages.

## [0.0.1] - 2013-10-01

### Added
- Initial version.
