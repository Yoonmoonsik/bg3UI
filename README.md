# Whiskey UI – for 21:9 Ultrawide

On a 21:9 WUHD screen (5120x2160), the vanilla hotbar and Party Panel use much less of the screen than they could.
Whiskey UI widens both, and adds spell slots and action resources to the character portraits.

## Features

### Hotbar
- **Wider hotbar.** Fills about 80% of the screen width.
- **All 12 Custom slots always visible.** The Custom section stays at 12 columns (keys 1–0, -, =)
  and can't be shrunk or pushed off the bar by accident.
- **Compact Passives section.** Starts at 3 columns. You can still resize it by dragging the Items border.
- **Resizable Items section.** The border on the right of the Items section can be dragged.
- **Cleaner bar.** The FixedSideBar section (e.g. Metamagic) appears only in its own panel to the right of the hotbar.
- **Party resources on the hotbar.** Camp supplies, inspiration and party gold are shown to the right of the rest button.

### Party Panel
- **Inventory:** 10 columns per character instead of 7.
- **Longer bars:** XP, weight and approval.
- **Wider sections:** spellbook and reactions.

### Character portraits
- **Remaining spell slots.** Shown just outside each portrait's bottom right corner, at all times.
  Used slots turn gray. Multiclass characters get one entry per slot type, with no duplicates.
- **Action, bonus action and reaction.** Shown above the spell slots, in combat only.
  Each icon changes when that resource is used.

### Reaction popup
- **Do Not React shortcut.** Press your Short Rest key to choose Do Not React. The button shows which key it is.

## Compatibility
- Keyboard & mouse mode only. Controller mode uses the vanilla UI.
- Replaces the vanilla hotbar, character portraits, Party Panel and reaction popup by overriding the `PlayerHUD`, `PartyPanel` and `ReactionsPopup` UI states.
  Other mods that also override them will conflict; whichever mod loads last wins.
- **Not compatible with ImpUI.**
