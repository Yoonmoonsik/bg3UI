# WhiskeyHotbar – Wide Hotbar for 21:9 WUHD

On a 21:9 WUHD screen (5120x2160), the vanilla hotbar uses only about half of the screen width.
WhiskeyHotbar widens it to about 80% of the screen so you can see more slots at once,
and keeps all 12 Custom slots (keys 1–0, -, =) visible on the main hotbar.

## Features
- **Wider hotbar.** The slot deck goes from 1498 to 2908 units, and the bottom frame is stretched to match.
- **All 12 Custom slots always visible.** The Custom section sits on the main hotbar at a fixed 12 columns.
  Its borders are locked and not drawn, so it can't be shrunk or pushed off the bar by accident.
- **Compact Passives section.** Passives start at 3 columns instead of taking up the leftover space.
  You can still drag the Items border to resize it.
- **Resizable Items section.** In vanilla, the border on the right of the Items section is hidden and locked.
  Here it is a normal draggable divider.
- **Cleaner deck.** The FixedSideBar section (e.g. Metamagic) is hidden inside the deck.
  It still appears in its own panel to the right of the hotbar, as in vanilla.

## Compatibility
- Keyboard & mouse mode only. Controller mode uses the vanilla hotbar.
- Overrides the `PlayerHUD` UI state. Other mods that also override `PlayerHUD` (for example ImpUI) will conflict;
  whichever mod loads last wins.
- Built from the current vanilla `HotBar.xaml`. A game patch that changes the hotbar may need an update to this mod.

## Files
| Path | Role |
|---|---|
| `Mods/WhiskeyHotbar_91315679-b595-84f5-14d6-4910c665b49e/GUI/Pages/WhiskeyHotBar.xaml` | Modified copy of vanilla `MainUI/GUI/Pages/HotBar.xaml` |
| `Mods/WhiskeyHotbar_91315679-b595-84f5-14d6-4910c665b49e/GUI/StateMachines/Keyboard.xaml` | Overrides `PlayerHUD`; same widgets as vanilla, with `HotBar.xaml` replaced by `WhiskeyHotBar.xaml` |

Every change in `WhiskeyHotBar.xaml` is marked with a `WhiskeyHotbar` comment.
Changes still waiting for in-game confirmation are marked `WhiskeyHotbar TEST`.

## Changes from vanilla `HotBar.xaml`
| Item | Vanilla | WhiskeyHotbar |
|---|---|---|
| `MaxDeckColumns` | 16 | 32 |
| `DeckWidth` / `FullWidth` | 1498 | 2908 |
| `DeckWidthShapeshift` | 1450 | 2860 |
| `FixedHotbarHiddenMargin` | 1600,6,0,-6 | 3008,6,0,-6 |
| `BarBottomBg` image | Stretch=None (2424x52) | Stretch=Fill, 3834x52 |
| `ItemHotBar` shutter | hidden, not draggable | shown, draggable |
| `PassivesHotBar` section | saved columns (e.g. 16) | SavedWidth 264 (3 columns); right shutter locked and not drawn |
| `FixedSideBar` section | shown in deck | collapsed in deck |
| `CustomHotBar` section | saved columns | SavedWidth 1056 (12 columns); shutter locked and not drawn |

## Notes for development
- **Deck sections are runtime data.** The deck's section list is `PlayerCharacterProperties.KeyboardHotBars`.
  It holds Common, Class, Item, Passives, FixedSideBar and Custom, in that order.
  Its contents are not in any unpacked file; multitool Index Search finds `KeyboardHotBars` only in `HotBar.xaml`.
  To read section values, temporarily bind a `TextBlock` inside `HotbarItemTemplate` to `HotBarType`,
  `CellColumns` and the item's `ActualWidth`. Place it inside the section; text above the section is clipped.
- **Section width** (`ConcertinaItem.ActualWidth`) = columns × 88 + 36 (shutter zone), measured in game.
  The sum of section widths stays the same when dividers are dragged.
- **Do not set `MinWidth`/`MaxWidth` on a section.** Dragging that section's shutter froze the game in testing.
- **Folder layout.** UI files go in `Mods/<mod folder>/GUI/`, not `Data/<mod>/` as the official guide says
  (per the guide's comments, changed in Patch 7). XAML namespaces must use `http://`, not `https://`.

## Verification status
**Verified in game (5120x2160):**
- Hotbar at about 80% of the screen width (measured at deck width 2906)
- Items shutter draggable
- Passives 3 columns, resets to 3 on reload, still resizable
- Custom right shutter not draggable
- Custom 12 columns (deck width 3120, before FixedSideBar was collapsed)
- Deck section column sums matched across Barbarian, Wizard and Cleric

**Not yet verified (`WhiskeyHotbar TEST`):**
- FixedSideBar collapsed in the deck, with deck width 2908
- Custom left shutter (Passives' shutter) locked
- Both Custom shutters hidden
- Custom slots in key order 1–0, -, =
