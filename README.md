# Whiskey UI – for 21:9 Ultrawide

On a 21:9 WUHD screen (5120x2160), the vanilla hotbar and Party Panel use much less of the screen than they could.
Whiskey UI widens both: the hotbar fills about 80% of the screen width and keeps all 12 Custom slots
(keys 1–0, -, =) visible, and the Party Panel gives each character a wider inventory, spellbook and sheet.

## Features

### Hotbar
- **Wider hotbar.** The slot deck goes from 1498 to 2908 units, and the bottom frame is stretched to match.
- **All 12 Custom slots always visible.** The Custom section sits on the main hotbar at a fixed 12 columns.
  Its borders are locked so it can't be shrunk or pushed off the bar by accident;
  the left border is drawn gray and the right border is not drawn.
- **Compact Passives section.** Passives start at 3 columns instead of taking up the leftover space.
  You can still drag the Items border to resize it.
- **Resizable Items section.** In vanilla, the border on the right of the Items section is hidden and locked.
  Here it is a normal draggable divider.
- **Cleaner deck.** The FixedSideBar section (e.g. Metamagic) is hidden inside the deck.
  It still appears in its own panel to the right of the hotbar, as in vanilla.
- **Party resources on the hotbar.** Camp supplies, inspiration and party gold (the Party Panel header)
  are shown to the right of the rest button.

### Party Panel
- **Inventory:** 10 columns per character instead of 7.
- **XP bar and weight bar:** 300 units longer.
- **Spellbook:** class, known-spells, prepared-spells and search sections are 276 units wider.
  The prepared-spells frame uses redrawn 960-wide images.
- **Reactions:** each reaction row is 220 units wider.
- **Character Sheet:** the approval bar is 300 units longer.

## Compatibility
- Keyboard & mouse mode only. Controller mode uses the vanilla UI.
- Overrides the `PlayerHUD` and `PartyPanel` UI states. Other mods that also override them
  (for example ImpUI, which overrides `PlayerHUD`) will conflict; whichever mod loads last wins.
- Built from the current vanilla `HotBar.xaml`, `PartyPanel.xaml` and the shared templates listed below.
  A game patch that changes them may need an update to this mod.

## Files
All paths are under `Mods/WhiskeyHotbar_91315679-b595-84f5-14d6-4910c665b49e/` (the folder keeps its original name).

| Path | Role |
|---|---|
| `GUI/Pages/WhiskeyHotBar.xaml` | Modified copy of vanilla `MainUI/GUI/Pages/HotBar.xaml` |
| `GUI/Pages/WhiskeyPartyPanel.xaml` | Modified copy of vanilla `MainUI/GUI/Pages/PartyPanel.xaml`, plus local copies of the shared templates it changes |
| `GUI/StateMachines/Keyboard.xaml` | Overrides `PlayerHUD` and `PartyPanel`; same widgets and events as vanilla, with the two pages replaced |
| `GUI/Assets/SpellBook/preparedBoxTile_small_{top,middle,bottom}_Whiskey.DDS` | Prepared-spells frame redrawn at 960 wide (BC7_UNORM_SRGB, like vanilla) |
| `GUI/metadata.lsf` | Registers the three images above (path, width, height, mip count) |

Every change in the two pages is marked with a `WhiskeyHotbar` comment.
Changes still waiting for in-game confirmation are marked `WhiskeyHotbar TEST`.

## Hotbar: changes from vanilla `HotBar.xaml`
| Item | Vanilla | Whiskey UI |
|---|---|---|
| `MaxDeckColumns` | 16 | 32 |
| `DeckWidth` / `FullWidth` | 1498 | 2908 |
| `DeckWidthShapeshift` | 1450 | 2860 |
| `FixedHotbarHiddenMargin` | 1600,6,0,-6 | 3008,6,0,-6 |
| `BarBottomBg` image | Stretch=None (2424x52) | Stretch=Fill, 3834x52 |
| `ItemHotBar` shutter | hidden, not draggable | shown, draggable |
| `PassivesHotBar` section | saved columns (e.g. 16) | SavedWidth 264 (3 columns); right shutter locked and drawn with saturation 0 |
| `FixedSideBar` section | shown in deck | collapsed in deck |
| `CustomHotBar` section | saved columns | SavedWidth 1056 (12 columns); shutter locked and not drawn |
| Party resources | — | `HeaderInspirationPointsGold` (Library/DataTemplates.xaml) next to the rest button |

## Party Panel: changes from vanilla
| Item | Vanilla | Whiskey UI |
|---|---|---|
| Character panel width | `Width="808"` | 808 + 3 × `ScaledSlotSize` (fixed width via `AddMultipleConverter`) |
| `PanelViewRoot` `MaxWidth` | 4120 | 5388 (4 panels × 3 slots × 105.6) |
| XP bar | shared `XPBarTemplate`: fill 300, background 364 | `WhiskeyXPBarTemplate`: fill 600, background 664 |
| Weight bar | shared `WeightBarTemplate`: bar 448, fixed-size images | `WhiskeyWeightBarTemplate`: bar 748; background 804, carry-limit 804, overlay 752 as nine-slice images |
| Spellbook class column / known spells | 684 / 690 | 960 / 966 (`WhiskeySpellbookTemplate`) |
| Spellbook class and search frames | 668 (from image) | 944, edge art stretched |
| Spellbook prepared-spells frame | 684 (from image) | 960, redrawn images |
| Reaction row | 700 (`InterruptToggleBtnTemplate`) | 920 (`WhiskeyInterruptToggleBtnTemplate`, `WhiskeyInterruptPanelTemplate`) |
| Approval bar | `CharSheetTabController`: background 504, bar 448, overlay 452 | `WhiskeyCharSheetTabController`: 804 / 748 / 752 |

The local template copies are used only by `WhiskeyPartyPanel.xaml`; the shared library is not changed.
Source templates (all under `Public/Game/GUI/Library/`):
`CharacterSheetTemplates.xaml` (XP bar, weight bar), `CharacterSheetTemplates_k.xaml` (spellbook, reactions panel,
character sheet), `DataTemplates.xaml` (reaction row, party resources).

The inventory grid (`InventoryGridStyle` in `CharacterSheetTemplates_k.xaml`) has no column count;
its columns follow the panel width. `ScaledSlotSize` depends on the UI scale setting (70.4–105.6), so the panel grows by
whole slots at every scale. The spellbook and reaction widths are fixed numbers sized for `ScaledSlotSize` 92.

## Notes for development
- **Deck sections are runtime data.** The deck's section list is `PlayerCharacterProperties.KeyboardHotBars`.
  It holds Common, Class, Item, Passives, FixedSideBar and Custom, in that order.
  Its contents are not in any unpacked file; multitool Index Search finds `KeyboardHotBars` only in `HotBar.xaml`.
  To read section values, temporarily bind a `TextBlock` inside `HotbarItemTemplate` to `HotBarType`,
  `CellColumns` and the item's `ActualWidth`. Place it inside the section; text above the section is clipped.
- **Section width** (`ConcertinaItem.ActualWidth`) = columns × 88 + 36 (shutter zone), measured in game.
  The sum of section widths stays the same when dividers are dragged.
- **Do not set `MinWidth`/`MaxWidth` on a section.** Dragging that section's shutter froze the game in testing.
- **Fix panel widths, don't just pad them.** A hidden spacer only sets a minimum width; the Character Sheet tab
  then stretched the panel and the inventory grew to 17 columns.
- **A `StaticResource` must be defined before it is used** in the same dictionary. The weight bar copy is referenced
  from a template above it, so that reference is a `DynamicResource`.
- **Images.** Mod images go in `GUI/Assets/...` and are referenced as `pack://application:,,,/Core;component/Assets/....png`
  (same as BetterHotbar). Register each one in `GUI/metadata.lsf`; edit it by converting with Divine.exe
  (`convert-resource`, LSF ↔ LSX).
- **Folder layout.** UI files go in `Mods/<mod folder>/GUI/`, not `Data/<mod>/` as the official guide says
  (per the guide's comments, changed in Patch 7). XAML namespaces must use `http://`, not `https://`.

## Verification status
**Verified in game (5120x2160):**
- Hotbar at about 80% of the screen width (measured at deck width 2906)
- Items shutter draggable
- Passives 3 columns, resets to 3 on reload, still resizable
- Custom right shutter not draggable; Custom 12 columns (deck width 3120, before FixedSideBar was collapsed)
- Custom left shutter drawn gray
- Deck section column sums matched across Barbarian, Wizard and Cleric
- Party resources shown next to the rest button
- Party Panel inventory 10 columns; panel width stays fixed when switching to the Character Sheet tab
- XP bar longer and still switches to the Level Up button; weight bar pointer, limits and carry-limit background in place
- Spellbook class, prepared-spells and known-spells sections line up at the wider width (seen in screenshots)
- Approval bar longer

**Not yet verified (`WhiskeyHotbar TEST`):**
- FixedSideBar collapsed in the deck, with deck width 2908
- Custom left shutter (Passives' shutter) locked
- Custom right shutter hidden
- Reaction row at 920 (976 touched the panel edge)
- Custom slots in key order 1–0, -, =
