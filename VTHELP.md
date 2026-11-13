# VTHELP — DOS-style .vth Help File Viewer

![screenshot placeholder](docs/screenshot3.png)

---

VTHELP is a compact help file viewer with a classic two-pane
DOS look. The left pane shows a grouped topic index; the right pane renders the
selected topic with syntax highlighting, clickable cross-reference links, and a
back-navigation stack. By default it loads **`vt.vth`** — the official offline
API reference for **libvt** — but it can open any `.vth` file you write yourself.

---

## Features

- Two-pane layout — grouped topic index on the left, content on the right
- Keyboard and mouse navigation throughout
- Clickable cross-reference links with Tab / Shift+Tab cycling
- Back-navigation stack (up to 32 levels deep) — Escape goes back
- Syntax-highlighted sections: syntax, parameters, notes, examples, see-also
- Mouse wheel scrolling in both panes
- Copy/paste support (Shift+Ins)
- Loads `vt.vth` automatically from the current directory when no argument given (vthelp + vth file must be in the same dir)
- Opens any custom `.vth` file passed as a command-line argument
- File association helpers for Windows (`vthelp-register.bat`) and Linux (`vthelp-register.sh`)
- Single-file executable, no installer

---

## Keyboard Reference

| Key | Action |
|---|---|
| **F1** | Focus the index pane |
| **F2** | Focus the content pane |
| **Tab** / **Shift+Tab** | Cycle through cross-reference links in content |
| **Enter** | Open selected topic (index) or follow focused link (content) |
| **Escape** | Navigate back (or beep if at the root) |
| **Up** / **Down** | Move selection / scroll one line |
| **PgUp** / **PgDn** | Scroll one page |
| **Home** / **End** | Jump to the top / bottom |

Mouse clicks on index entries and content links are also supported, as is
left-button drag-to-select and right-button copy to the clipboard.

---

## Building

```sh
fbc vthelp.bas
```

The `#cmdline` directive in the source already sets optimisation and
GUI-subsystem flags, so no extra compiler arguments are needed.

---

## Runtime Dependencies

| Library | Notes |
|---|---|
| SDL2 (core only) | Required by libvt at runtime |

Pre-built SDL2 binaries for Windows can be found in the
[fb-lib-archive](https://github.com/rbreitinger/fb-lib-archive/tree/main/libraries/SDL2/SDL2-2.0.14).

Place `SDL2.dll` next to the compiled executable on Windows.
On Linux, install SDL2 via your package manager (`libsdl2-dev` / `sdl2`).

---

## Usage

```sh
vthelp                  # loads vt.vth from the current directory
vthelp myfile.vth       # loads a custom help file
```

Double-clicking a `.vth` file works automatically after running the file
association helper for your platform (see below).

---

## File Association

Run the appropriate helper from the `utils/` directory to associate `.vth`
files with VTHELP so they open on double-click.

**Windows** — run as Administrator:

| File | Action |
|---|---|
| `vthelp-register.bat` | Associates `.vth` with `vthelp.exe` |
| `vthelp-unregister.bat` | Removes the association |

**Linux** — user-level, no root required:

| File | Action |
|---|---|
| `vthelp-register.sh` | Registers MIME type and `.desktop` entry for `.vth` |
| `vthelp-unregister.sh` | Removes the registration |

The registration points to the vthelp binary in the same directory as the
script, so keep them together with the executable.

---

## The .vth Format

`.vth` files are plain text. Topics are separated by `:topic` tags and
organised into named groups. Lines beginning with `'` are comments and are
ignored by the parser (except inside `:example` blocks).

```
' ---- group: My Group ----
:topic my_function
:short One-line description shown in the index
:group My Group
Introductory paragraph. Describe what the function does in plain prose here. 
This paragraph can be multiple lines.
:syntax
Function my_function(x As Long, y As Long) _
                     As Long
:params
x  The first value.
y  The second value.
:notes
Any return values, caveats or platform differences go here.
This can be multiline as well.
  also it can be formatted verbatim.
:example
Dim result As Long = my_function(10, 20)
vt_print Str(result) & VT_LF
vt_present()
:see
other_function
another_function
```

### Tag reference

| Tag | Purpose |
|---|---|
| `:topic <name>` | Starts a new topic. `name` is the link target used in `:see` entries. |
| `:short <text>` | One-line summary shown in the index pane. |
| `:group <name>` | Group heading the topic appears under. Defaults to `General`. |
| `:syntax` | Function signature(s). Rendered in bright green verbatim. |
| `:params` | Parameter descriptions. Rendered verbatim. |
| `:notes` | Notes, caveats, return values. Rendered verbatim. |
| `:example` | Code example. Comment lines (`'`) are preserved here. |
| `:see` | Cross-reference links — one topic name per line, one per link. |

---

## License

MIT License — Copyright © 2026 Rene Breitinger

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
