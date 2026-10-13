# Mobs Dinos

A [Luanti](https://www.luanti.org) (Minetest) mod that adds four dinosaurs to
[Mobs Redo](https://codeberg.org/tenplus1/mobs_redo).

| Mob | Behaviour | HP | Damage |
|-----|-----------|----|--------|
| Raptor (`mobs_dinos:raptor`) | attacks players on sight | 18-24 | 4 |
| Ribbedhead (`mobs_dinos:ribbedhead`) | attacks players on sight | 22-30 | 5 |
| Bronto (`mobs_dinos:bronto`) | only fights back when attacked | 55-70 | 7 |
| Pentasaurus (`mobs_dinos:pentasaurus`) | only fights back when attacked | 30-40 | 5 |

- All are `type = "monster"` (so they do not spawn in peaceful mode).
- They spawn naturally on soil/sand and have spawn eggs (`mobs_dinos:<name>_egg`).
- They cannot swim (they sink) and take water and lava damage.

## Taming and riding

- Spawn eggs create **tamed** dinos owned by you (hold sneak to spawn a wild one).
- Wild dinos are tamed by feeding them raw meat (`mobs:meat_raw`) 4 times.
- A tamed dino can be ridden by its owner: right-click to mount, right-click
  again to dismount. Steer with the movement keys / look direction.
- Tamed dinos no longer attack players.

## Animation

Luanti plays only one glTF animation, so each model contains a single
continuous timeline (1 frame = 1 second):

- `walk`: frames 0 - 1
- `idle`: frames 2 - 5

`tools/merge_anims.py` converts models exported with separate `walk` / `idle`
animations into this layout.

## Requirements

- Luanti 5.10+ (glTF support)
- `mobs` (Mobs Redo)

Drops use `mobs:meat_raw` and `mobs:leather` from Mobs Redo.

## Tweaks

- If a model walks sideways or backwards, change `MODEL_ROTATE` in `init.lua`.
- Size is controlled by `visual_size` and `collisionbox` per dino.
- Spawn rates can be overridden in `minetest.conf`, e.g. `mobs_dinos:raptor = 1,7000`
  (Mobs Redo setting).

## License

MIT, see [LICENSE.md](LICENSE.md). Copyright (c) 2026 ronrob-lu.
