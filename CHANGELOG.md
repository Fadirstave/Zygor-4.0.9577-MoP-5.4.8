# Changelog

## 2026-09-12

### Added
- Per-character, per-specialization gear stat weights in Interface > AddOns > Zygor > Gear suggestions.
- Specialization selector, customization toggle, validated weights from 0 to 1000, and a reset action.
- Support for zero weights and restoring an individual stat to its original weight by clearing its field.

### Fixed
- Active scoring now uses copies of the default rules, preventing hit/expertise adjustments from modifying the original tables.
- Custom hit/expertise weights also update the baseline used by the legacy cap calculation.
- Weight changes clear gear score caches and pending recommendations before rescoring.
- Disabling gear suggestions closes the current popup and clears pending gear recommendations.
- The gear popup entry point now checks whether gear suggestions are enabled.

### Validation
- Passed Lua 5.1 syntax checks and scoring/settings regression tests using game API stubs.
- Live game UI rendering and equipment actions have not been tested.
- The reported blank settings panels remain an in-game verification item.
