# anshul333y's hyprland installer script

printf '\033c'
echo "Welcome to anshul333y's hyprland installer script"

mkdir code dl pub docs music pics vids ~/.local/share
sudo pacman -S --noconfirm git openssh zsh stow bluez bluez-utils cronie
chsh -s /usr/bin/zsh
systemctl enable bluetooth.service
systemctl enable cronie.service
git clone https://github.com/LazyVim/starter ~/.config/nvim
git clone https://github.com/anshul333y/.dotfiles.git
cd ~/.dotfiles && stow . && cd

# Installing ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use

# Installing Paru
git clone https://aur.archlinux.org/paru-bin.git ~/dl/paru
cd ~/dl/paru && makepkg -si --noconfirm && cd && rm -rf ~/dl/paru

# Installing Packages
sudo pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-joypixels ttf-font-awesome \
  hyprland hyprpaper hypridle hyprlock rofi-wayland waybar dunst polkit-gnome gnome-keyring \
  xdg-desktop-portal-hyprland qt5-wayland qt6-wayland xdg-desktop-portal-gtk xdg-user-dirs \
  brightnessctl acpi pacman-contrib python-pywal uwsm xorg-xrdb ntfs-3g udisks2 \
  kitty wl-clipboard nvim lazygit fzf ripgrep fd tmux nodejs npm docker \
  firefox chromium telegram-desktop discord flatpak sxiv yazi mpv mpd ncmpcpp mpc

paru -S --noconfirm maplemono-nf-cn-unhinted python-pywalfox hyprshot-git wlogout-git \
  spotify-adblock-git microsoft-edge-stable-bin brave-bin visual-studio-code-bin

flatpak install --noninteractive flathub com.github.wwmm.easyeffects
