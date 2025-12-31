This repo contains some files from [1amSimp1e](https://github.com/1amSimp1e)'s [dotfiles](https://github.com/1amSimp1e/dots/tree/balcony%F0%9F%9A%8A) (it is only waybar and its customs rn)

- Wallpaper folder is ~/Pictures/Wallpapers
- tested only on arch

---
## Dependencies
- dunst
- fish
- firefox
- hypridle
- hyprland
- hyprlock
- inotify-tools
- jq
- kitty
- light
- neovim
- nerdfonts (for lazyvim)
- pamixer
- pandoc
- perl
- pywal16
- rofi
- starship
- awww
- yad

---
## To install all dependencies:
### Arch:
```bash
paru -S \
dunst fish zen-browser-bin hypridle hyprlock inotify-tools jq kitty light \
neovim nerd-fonts pamixer pandoc perl python-pywal16 rofi starship swww yad --needed
```

---
## To copy these dotfiles do:
```bash
cp -r ~/.config ~/.config-backup && \
git clone https://github.com/batat222/dotfiles.git && \
cp dotfiles/ .config && \
rm -rf ~/.config/.git
```

---
## Plans
1. New network module
2. Installation script
3. Laptop and desktop versions
4. Warhammer 40k inspired dotfiles

---
Thanks [1amSimp1e](https://github.com/1amSimp1e) for dotfiles (used them as a base)
