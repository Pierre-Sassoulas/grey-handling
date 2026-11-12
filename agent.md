# Testing a new GreyHandling release

## Branch workflow

Fixes always go on `main` first. After committing on `main`:
1. `git checkout retail && git rebase main` — resolve TOC conflicts if any
2. After retail is validated, redo `wow-forever` on the retail model (see below)

## Update interface version

Check the current client interface by looking at a known-good addon (e.g. BagBrother):
```
Get-Content "E:\Wow\World of Warcraft\_retail_\Interface\AddOns\BagBrother\BagBrother.toc" | Select-String "Interface"
```
Update `GreyHandling.toc` on the `retail` branch to match if outdated.

## API surface check (run once per WoW patch)

In `constants.lua`, set `DEVELOPMENT_VERSION = true`.  
In `tests/Tests.lua`, uncomment the `GreyHandling.checkAPI()` line in `allTests()`.  
`/reload` in-game, then press **Ctrl+Shift**.

- `[MISSING]` in red = broken API, needs a new alias in `CompatRetailClassic.lua`
- `[GROUP]` in yellow = group function exists, return value shown (0/false solo is expected)
- Green summary = all clear

Revert both changes before committing.

## Manual test checklist (solo, Starter Edition)

- [ ] Item tooltip shows sell price (hover any item in bag)
- [ ] Shift+Ctrl left = main flow runs, cheapest item highlighted
- [ ] Loot tooltip on full bag: "Take it / Leave on corpse" message appears
- [ ] Options panel opens (`/gh` or keybind)
- [ ] All of the above work **in combat** (Forever restricts some data in combat)

## Not testable on Starter Edition

- Group sharing (addon message exchange)
- Mutually beneficial trades

## wow-forever branch

Based on `retail`. After retail is validated:
- TOC: `## Interface: 16001` only, version `1.60.1_{addon_version}`
- Keep the two retail-specific commits (ArkInventory guard, title without icon)
- Use `GreyHandling_Camelot.toc` for BigWigs/CurseForge packager compatibility
- Test logs: `E:\Wow\World of Warcraft\_forever_\Logs\General.log`
