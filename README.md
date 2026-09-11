# Big Bags

More space in your inventory, longer reach, and bigger stacks, for [Factorio](https://factorio.com). Available on the [mod portal](https://mods.factorio.com/mod/BigBags).

## What it does

**Technologies.** Five levels of `inventory-size` add inventory slots, 30 per level for the first three and 20 for the last two, so 130 in total. Five levels of `pickstick` extend build, item drop, reach, and resource reach distance by 12 times the level number, so the first level adds 12 and the fifth adds 60, plus half a tile of loot pickup range each. Seven further levels of `worker-robots-storage` extend the base game's three, each adding one slot of robot cargo.

The robot storage levels are registered in `data-updates` so that other mods can be seen first. Bob's Logistics and 5Dim's New Logistic turn that research infinite, and Factorio refuses to load a finite level after an infinite one, so when another mod already owns the chain the mod leaves it alone.

**Stack sizes.** Independent of any research, every item's stack size is rewritten as `offset + size * factor`. The result is never smaller than the original, so another mod's deliberately larger stacks survive, and multiplying preserves whatever ratios the rest of your mod set chose. Items that cannot stack are skipped: anything already at 1, and anything flagged `not-stackable` or `only-in-cursor`.

## Settings

All are startup settings, changed from the mod settings screen.

| Setting | Default | Effect |
| --- | --- | --- |
| Stack factor | 10 | Multiplies every item's stack size |
| Stack offset | 0 | Added to every item's stack size |
| Magazine factor | 10 | Multiplies every ammo magazine size |
| Magazine offset | 0 | Added to every ammo magazine size |
| Default request amount | 10 | Logistic request default per item. 0 leaves each item's own default alone |
| Running speed factor | 1 | Multiplies character running speed. Only applies while the vanilla value is unchanged, so it will not fight another mod |

## Maintenance

Created by **BinbinHfr**, who maintained it from 2016 to 2019 and again for 1.0.37. Maintained by **Myricaulus** from 1.0.30 to 1.0.35, by **Svarogich** for the Factorio 2.0 port, and by **Sparr** from 2.1.0 onward, each with the original author's permission.

See `LICENSE.txt` for terms. It is BinbinHfr's own license, not an OSI one, and it permits continued maintenance under the conditions stated there.

## Development

The test suite drives a real headless Factorio and checks what the data stage actually produced, since almost all of this mod is prototype rewriting that would otherwise fail silently.

```sh
npm install
npm test                # whole suite
npm test -- "stack"     # only tests matching a Lua pattern
```

It expects a Factorio install at `~/.local/share/factorio-versions/2.1.17/bin/x64/factorio`; set `BB_FACTORIO` to point somewhere else. A throwaway data directory is used outside the repo, overridable with `BB_FT_DATA`.

Build a release zip with `npx fmtk package`.
