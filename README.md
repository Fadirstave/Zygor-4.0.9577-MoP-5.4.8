# Zygor 5.4.8 Gear Priorities

Adds editable gear stat weights to Zygor Guides Viewer 4.0.9577 for the original World of Warcraft 5.4.8 client.

## Using the settings

1. Reload the game UI with `/reload` after installation.
2. Open Interface > AddOns > Zygor > Gear suggestions.
3. Choose the specialization to edit and enable **Use custom weights for this specialization**.
4. Enter a weight for each stat and confirm each field with its Okay button or Enter. Higher weights make each point of that stat more valuable. For example, Haste 20 and Critical strike 10 value one point of haste twice as much as one point of critical strike.
5. Use 0 to ignore a stat, or clear its field to restore its original weight. **Reset this specialization** removes its custom weights and disables customization.

The selected specialization is the one being edited. Recommendations always follow the character's current specialization. Weights are stored per character and specialization in the existing saved-variable database. Disabling customization preserves entered weights for later use.

To stop gear popups, turn off **Suggest equipping new gear**. This also stops automatic gear upgrades. **Equip automatically** remains the existing separate option.

## Installation

Close WoW or reload after replacing files. Copy the `ZygorGuidesViewer` folder into the 5.4.8 client's `Interface/AddOns` directory. Back up your existing addon first. Do not install this version into modern MoP Classic.

For an existing copy of 4.0.9577, the patch changes only `Options.lua`, `Item-ItemScore.lua`, `Item-AutoEquip.lua`, and `files.xml`, and adds `Item-GearPriorities.lua`. Other addon files do not need replacing.

## Behavior and limits

The implementation follows the supplied modern Classic addon's per-specialization weight overrides and immutable base rules. It retains the 2014 addon's default weights and equipment restrictions. Modern default numbers have not been substituted for the original client's rules.

Existing hit/expertise cap adjustments, socket estimates, heirloom bonuses, and weapon restrictions still affect recommendations. This is a weighted stat comparison, not a combat simulator or a reforge optimizer. A weight of zero removes that stat's contribution; it does not remove other bonuses on the item.

Changing weights clears cached upgrade scores, pending recommendations, and Gear Finder results before rescoring equipment and bags. Automatic equipping, if enabled, still uses the existing combat restrictions.

## Validation

Lua 5.1 syntax checks passed for every changed Lua file. Tests with game API stubs exercised the actual scoring routine, zero weights, hit-cap adjustments, specialization isolation, preserved defaults, validation, resets, cache clearing, and full settings-table creation.

In-game rendering and equipment actions still need verification in a running 5.4.8 client. The reported blank settings tabs were not reproduced by the settings-table test; this patch does not claim to resolve an unidentified UI or addon-conflict issue.

## In-game checks

- Open Gear suggestions, enter weights, and confirm a relevant comparison changes.
- Switch specialization, then switch back; confirm each specialization retains its values.
- Reload and confirm the weights persist.
- Disable gear suggestions with a popup visible; confirm it closes and stays closed after a bag update.
- Reset the specialization and confirm the original scoring returns.
- Check Gear suggestions, Extra Features, and Notifications for display errors.

## Source and publishing

Based on the user's supplied 4.0.9577 archive and installed modern Classic addon. Original author and license metadata remain unchanged. The README and changelog are ready for a repository; no commits or remote publication were performed.
