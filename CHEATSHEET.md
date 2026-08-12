# Corne Choc Pro — cheat sheet

Generated from `config/corne_choc_pro.keymap`. Keep in sync when the keymap changes.

Positions are described by **physical column**, left half, 1 = pinky … 5 = inner index,
6 = the extra inner column (top and home rows only). Letters in brackets are the Gallium
base-layer legends for the same key.

---

## If the keyboard has gone silent — read this first

Everything that can break connectivity lives on the **SYSTEM layer**, and there is exactly
one way in.

### Getting into SYSTEM

**Hold three keys together for a full second:**

| Key | Where |
|---|---|
| `[D]` | top row, column 3 |
| `[W]` | bottom row, column 4 |
| `CMD` | middle key of the three left thumb keys |

All on the **left half**, so this works with the right half off, flat or unpaired.

It is a **hold, not a tap** — 750 ms. A quick press does nothing but return you to the base
layer. That is the whole point: a hand grabbing the board, or the board squashed in a bag,
presses keys momentarily and can no longer reach anything dangerous.

### Once you're in

| What | Where | Notes |
|---|---|---|
| BT profile 0–4 | home row, columns 1–5 | One tap each. Walk them in order. |
| `OUT_TOG` (USB ↔ BLE) | bottom row, column 5 | Blind toggle. ZMK **persists** it — a board left on USB goes silent when unplugged. |
| `BT_CLR` | bottom row, column 4 | Wipes the bond on the **current profile only**. Unpair on the host too, then re-pair. |
| Studio unlock | bottom row, column 1 | |
| RGB toggle | bottom row, column 2 | |
| **Back to base** | inner left thumb key | Or the `N + Q` panic combo, from any layer. |

Every other key on SYSTEM does nothing at all.

**Recovery order:** `OUT_TOG` → walk BT profiles 0–4 → `BT_CLR` + unpair on host + re-pair.

Before any of that: check the **physical on/off switch on the inner side of each half**
(down = disconnected from battery, up = on).

### If nothing responds at all

Check whether the board is sat in its UF2 bootloader — it presents as a USB drive and no
HID keyboard, so no keypress can do anything:

```
system_profiler SPUSBDataType | grep -A8 -i keebart
ioreg -c IOHIDDevice -r -d1 | grep '"Product"'
```

If it's mass-storage only, flash `firmware/corne_choc_pro_{left,right}-zmk.uf2` onto the
`KEEBART` volume.

---

## Bootloader

**Not reachable from the base layer.** Get into SYSTEM first (above), then press
`[B]` + `[Q]` together — top and bottom of the left pinky column.

The old global `B + Q` combo is gone. It fired on any layer and put the board in the
bootloader by accident three times.

Hardware fallback: double-press the reset button on the underside (next to a screw) with a
SIM tool → board mounts as `KEEBART` → drag the `.uf2` on.

---

## Combos (fire on any layer unless noted)

| Combo | Physical keys | Does |
|---|---|---|
| **SYSTEM** | `[D]` + `[W]` + `CMD` thumb, **held 750 ms** | Layer 4. Short press = back to base. |
| Latch NUMBER | bottom row cols 1 + 2 `[Q + X]` | Same combo to leave |
| Latch SYMBOL | right hand `[; + .]` | Same combo to leave |
| Toggle QWERTY | right pinky column, top + bottom `[, + .]` | Same combo to come back |
| **Panic → base layer** | left pinky, home + bottom `[N + Q]` | Unconditional `&to 0` |
| Bootloader | left pinky column, top + bottom `[B + Q]` | **SYSTEM layer only** — inert elsewhere |

Latch combos are 150 ms; SYSTEM entry is 150 ms to chord plus a 750 ms hold; QWERTY and
bootloader are 50 ms.

---

## Layers

0 `GALLIUM` · 1 `NUMBER` · 2 `SYMBOL` · 3 `QWERTY` · 4 `SYSTEM` · 5–9 empty

- Thumbs: left = `ESC/NUMBER`, `CMD`, `SPACE` · right = `RET`, `TAB/SYMBOL`, `BSPC`
- Home-row mods, **left hand only**: Shift `[T]`, Option `[S]`, Ctrl `[G]`. Pinky and ring carry no holds.
- Hold `[Z]` = Ctrl+B (tmux/herdr prefix).
- Sticky Shift on the left extra-column home key.

### NUMBER (layer 1)

F1–F5 on the top row; numpad `789 / 456 / 123 / 0` under the right hand with the operators
on the outer columns. Caps-word on bottom row column 3. Cmd+Shift+4 on home row column 1,
Cmd+Shift+5 on the right extra column. Cmd+` on the right half's top row column 6
(the right dial's press).

No connectivity keys — they moved to SYSTEM. The left half is otherwise `&none`.

---

## Encoders

| Layer | Left dial | Right dial |
|---|---|---|
| GALLIUM | volume | track skip |
| NUMBER | herdr pane cycle (press = zoom pane) | Cmd+Tab app switcher (press = window cycle) |
| SYMBOL | undo / redo | volume |

---

## Flashing

`firmware/` holds current builds plus `settings_reset-*` images for wiping stored BT bonds
and the persisted output preference. Builds come from GitHub Actions via `build.yaml`.
