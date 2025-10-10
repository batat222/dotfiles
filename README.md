This repo contains some files from [1amSimp1e](https://github.com/1amSimp1e)'s [dotfiles](https://github.com/1amSimp1e/dots/tree/balcony%F0%9F%9A%8A) (it is only waybar rn)

- Wallpaper folder is ~/Pictures/Wallpapers
- tested only on arch

### Dependencies
- dunst
- fish
- zen browser
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
- swww
- yad

To install all dependencies:
```bash
paru -S \
dunst fish zen-browser-bin hypridle hyprlock inotify-tools jq kitty light \
neovim nerd-fonts pamixer pandoc perl python-pywal16 rofi starship swww yad --needed
```

To copy these dotfiles do:
```bash
cp -r ~/.config ~/.config-backup && \
git clone https://github.com/batat222/dotfiles.git && \
cp dotfiles/ .config && \
rm -rf ~/.config/.git
```

---
Thanks [1amSimp1e](https://github.com/1amSimp1e) for dotfiles (used them as a base, but changed almost everything)

