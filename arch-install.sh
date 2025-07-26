# anshul333y's arch installer script

#part1
printf '\033c'
echo "Welcome to anshul333y's arch installer script"
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true
lsblk
echo "Enter the drive: "
read drive
cfdisk $drive
echo "Enter the linux partition: "
read partition
mkfs.ext4 $partition
read -p "Did you also create efi partition? [y/n]" answer
if [[ $answer = y ]]; then
  echo "Enter EFI partition: "
  read efipartition
  mkfs.vfat -F 32 $efipartition
fi
mount $partition /mnt
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >>/mnt/etc/fstab
sed '1,/^#part2$/d' $(basename $0) >/mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit

#part2
printf '\033c'
pacman -S --noconfirm sed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >/etc/locale.conf
echo "KEYMAP=us" >/etc/vconsole.conf
echo "Hostname: "
read hostname
echo $hostname >/etc/hostname
echo "127.0.0.1       localhost" >>/etc/hosts
echo "::1             localhost" >>/etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >>/etc/hosts
mkinitcpio -P
passwd
pacman --noconfirm -S grub efibootmgr os-prober
echo "Enter EFI partition: "
read efipartition
mkdir /boot/efi
mount $efipartition /boot/efi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
sed -i 's/quiet/pci=noaer/g' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S --noconfirm dash zsh connman wpa_supplicant pipewire pipewire-pulse
systemctl enable connman.service
rm /bin/sh
ln -s dash /bin/sh
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/zsh $username
passwd $username
echo "Pre-Installation Finish Reboot now"
ai3_path=/home/$username/arch_install3.sh
sed '1,/^#part3$/d' arch_install2.sh >$ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
exit

#part3
cd $HOME
printf '\033c'
echo "Welcome to anshul333y's hyprland installer script"

mkdir code dl pub docs music pics vids ~/.local/share
sudo pacman -S --noconfirm git openssh zsh stow bluez bluez-utils cronie
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
exit
