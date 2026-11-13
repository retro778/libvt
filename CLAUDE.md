# CLAUDE.md — Session Rules & Repository Notes

## Session Rules

- **Push directly to `main`** — do NOT create feature or bugfix branches unless explicitly instructed.

---

## FreeBASIC Hard Rules

- `and`, `or`, `not`, `xor` are **bitwise** operators. Never use them for logical comparisons.
- Use `AndAlso` / `OrElse` for logical (short-circuit) comparisons.
- The `-o` switch is **not** the output filename — use `-x` instead:
  ```
  fbc myfile.bas -x myoutput
  ```

---

## Repository Structure

**libvt** is a self-contained DOS-style virtual text screen library for FreeBASIC, backed by SDL2 (default) or fbgfx (via `BACKEND_VT` define).

```
libvt/
├── vt/                     # Library source — all .bas/.bi
│   ├── vt.bi               # Single user-facing include: #include once "vt/vt.bi"
│   ├── vt_core.bas         # Core screen init, rendering, event pump (vt_screen, vt_present, vt_pump)
│   ├── vt_print.bas        # vt_print, vt_print_center, vt_locate, vt_color, etc.
│   ├── vt_keyboard.bas     # vt_inkey, vt_getkey, vt_key_held
│   ├── vt_mouse.bas        # vt_getmouse, vt_mouse
│   ├── vt_pages.bas        # vt_page, vt_pcopy (multiple display pages)
│   ├── vt_palette.bas      # vt_palette, vt_color_rgb
│   ├── vt_misc.bas         # vt_sleep, vt_title, vt_on_close, misc helpers
│   ├── vt_copypaste.bas    # Mouse copy/paste support
│   ├── vt_bsave.bas        # vt_bsave / vt_bload (.vts screen files)
│   ├── vt_font.bas         # vt_loadfont (custom font loading)
│   ├── vt_utf8.bas         # UTF-8 helpers (internal)
│   ├── vt_strings.bas      # String helpers (opt-in: VT_USE_STRINGS)
│   ├── vt_math.bas         # Math helpers   (opt-in: VT_USE_MATH)
│   ├── vt_file.bas         # File I/O       (opt-in: VT_USE_FILE)
│   ├── vt_sound.bas        # QBasic audio   (opt-in: VT_USE_SOUND)
│   ├── vt_tui.bas/.bi      # Text UI        (opt-in: VT_USE_TUI, pulls in STRINGS+FILE)
│   ├── vt_tui_dlg.bas      # TUI dialogs
│   ├── vt_tui_ed.bas       # TUI text editor widget
│   ├── vt_net.bas          # Sockets        (opt-in: VT_USE_NET)
│   ├── vt_tls.bas          # TLS 1.2/1.3   (opt-in: VT_USE_TLS, requires NET)
│   ├── vt_tls_glue.c       # C glue for mbedTLS
│   ├── libmbedtls_*.a      # Pre-built mbedTLS static libs (linux32/64, win32/64)
│   ├── driver/
│   │   ├── sdl2.bi         # SDL2 backend (default)
│   │   ├── fbgfx.bi/.bas   # fbgfx backend (define BACKEND_VT before include)
│   │   └── vt_font_8x*.bi  # Embedded CP437 fonts (8×8, 8×14, 8×16)
│   └── vt_font_8x*.bi      # (same font data, included by vt.bi)
├── examples/               # Runnable .bas examples for each feature area
│   └── vtsolitaire/        # VTSolitaire card game assets
├── utils/
│   ├── apidump.bas         # Extracts API signatures from vt/ source
│   ├── vthgen.bas          # Generates .vth help file from source doc-comments
│   ├── vth2html.bas        # Converts .vth to HTML
│   ├── vthelp.bas          # Offline help viewer (reads .vth files)
│   └── vthelp-register.*   # OS file-association scripts for .vth
├── docs/
│   ├── libvt.html          # Generated HTML API reference
│   ├── vt.vth              # Generated offline help file
│   └── libvt_api_dump.txt  # Raw API dump
├── build-examples.sh/.bat  # Compile all examples
└── build-docs.sh/.bat      # Regenerate docs/ (runs apidump → vthgen → vth2html)
```

### Key Architectural Points

- **Single-include design**: users do `#include once "vt/vt.bi"` — everything core is pulled in automatically. Optional modules are gated by `#define VT_USE_*` placed *before* the include.
- **Internal state**: all library state lives in one `Shared` variable `vt_internal As vt_internal_state` (defined in `vt.bi`).
- **Doc-comments**: functions are documented with `'>>>` / `'<<<` blocks parsed by `vthgen`. Editing these regenerates both the `.vth` and HTML docs via `build-docs.sh`.
- **Key packing**: `vt_inkey`/`vt_getkey` return a packed `ULong`. Use the `VT_CHAR(k)`, `VT_SCAN(k)`, `VT_SHIFT(k)`, `VT_CTRL(k)`, `VT_ALT(k)`, `VT_REPEAT(k)` macros to unpack — never compare the raw value against `VT_KEY_*` constants directly.
- **TUI module** (`VT_USE_TUI`): menubar, windows, dialogs, listbox, form, editor widget. Defined in `vt_tui.bi` (types/macros) + `vt_tui.bas` (implementation) + `vt_tui_dlg.bas` + `vt_tui_ed.bas`.
- **Backends**: SDL2 is the default. Setting `BACKEND_VT` before the include switches to fbgfx (for environments without SDL2).

### Building Examples

```bash
./build-examples.sh        # compiles all examples/*.bas
./build-docs.sh            # regenerates docs/ from source comments
fbc utils/vthelp.bas -x utils/vthelp   # offline help viewer
```
