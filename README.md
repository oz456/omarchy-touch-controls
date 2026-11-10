# Omarchy Touch Controls

> *Bar controls for 360° convertibles & touch laptops on Omarchy / Hyprland. Because your knees shouldn't type into your terminal.*

---

Running Hyprland on a 2-in-1 convertible laptop is peak Linux minimalism—until you fold the screen into tablet mode.

Suddenly, you hit the classic 360° combo:
1. Your lap accidentally types `rm -rf` with the keyboard folded flat against your knees.
2. You hold the tablet in portrait mode, but Hyprland keeps the screen landscape.
3. You tap a text input and remember that Linux doesn't give you a virtual keyboard by default.

**Touch Controls fixes that with three simple buttons on your Omarchy bar.**

---

## ⚡ The Controls

| Icon | Action | What it actually does |
| :---: | :--- | :--- |
| `󰌌` | **Virtual Keyboard** | Toggles `wvkbd-mobintl`, dynamically styled to match your active Omarchy theme colors (`colors.toml`). |
| `󰑮` | **Rotate Screen** | Cycles `eDP` orientation (0° &rarr; 90° &rarr; 180° &rarr; 270°) while keeping touch digitizers and styluses synced 1:1. |
| `󰓡` | **Flip Lock** | Toggles the internal AT keyboard off/on so holding the device in tablet mode doesn't turn your lap into a cat walking on keys. |

---

## 🚀 Installation

Install directly with Omarchy's shell plugin manager:

```bash
omarchy plugin add https://github.com/oz456/omarchy-touch-controls.git --enable
```

Omarchy will validate the manifest and place the widget into your top bar automatically.

---

## 🗑️ Removal

To disable or remove the plugin:

```bash
omarchy plugin disable touch-controls
omarchy plugin remove touch-controls
```

---

## 🎨 Theme Synchronization (Optional Hook)

To make `wvkbd` automatically reload its palette when you switch Omarchy desktop themes:

```bash
mkdir -p ~/.config/omarchy/hooks/theme-set.d/
ln -sf ~/.config/omarchy/plugins/touch-controls/hooks/20-osk-theme-sync.sh ~/.config/omarchy/hooks/theme-set.d/20-osk-theme-sync.sh
```

---

## 🛠 Dependencies

- **Hyprland** (with `hyprctl`)
- **`wvkbd-mobintl`** (for virtual keyboard support)
  ```bash
  sudo pacman -S wvkbd-mobintl
  ```
- **`jq`** (used by rotation and keyboard detection scripts)

---

## 📄 License

[MIT](LICENSE)
