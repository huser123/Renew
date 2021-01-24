#!/bin/bash 

echo ""
echo ""
echo ""
echo "Mi a felhasználó neve?"
read felhasznalo

echo ""
echo ""
echo "A script elindul..."
echo ""
echo ""
echo ""

### Telepítés kezdése!

mkdir -p /home/$felhasznalo/.config/autostart/

# RPM Fusion telepítése

echo ""
echo "Az RPM Fusion telepítése"
sleep 5s

dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Repositoryk beírása

echo ""
echo "Repositoryk beírása"
sleep 5s

# Opera böngésző repo

tee /etc/yum.repos.d/opera.repo <<RPMREPO
[opera]
name=Opera packages
type=rpm-md
baseurl=https://rpm.opera.com/rpm
gpgcheck=1
gpgkey=https://rpm.opera.com/rpmrepo.key
enabled=1
RPMREPO

# Visual Code repo

rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Csomagok telepítése

echo ""
echo "Az alap csomagok telepítésének megkezdése"
sleep 5s

dnf check-update

dnf install -y opera-stable code thunderbird flatpak snapd telegram-desktop megasync qbittorrent libreoffice libreoffice-langpack-hu VirtualBox ImageMagick kdenlive simplescreenrecorder smplayer kcm_wacomtablet gimp gscan2pdf texmaker audacity yakuake kdocker gnome-disk-utility tar ark zstd

dnf install -y https://download.cdn.viber.com/desktop/Linux/viber.rpm
dnf install -y https://code-industry.net/public/master-pdf-editor-5.7.08-qt5_included.x86_64.rpm

# NVIDA alapú gépen!

# dnf install nvidia-settings akmod-nvidia

echo ""
echo "A Snap és Flatpak csomagok telepítése"

systemctl start snapd && systemctl enable snapd

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
ln -s /var/lib/snapd/snap /snap

snap install spotify
snap install signal-desktop
flatpak install -y flathub org.geogebra.GeoGebra



# Beállítások

echo ""
echo "Egyéb beállítások"
sleep 5s

gpasswd -a $felhasznalo vboxusers


# automatikus indítások

echo ""
echo "Az automatikus indítások előkészítése"
sleep 5s


# ----

tee /home/$felhasznalo/.config/autostart/org.qbittorrent.qbittorrent.desktop <<EDDIG
[Desktop Entry]
Categories=Network;FileTransfer;P2P;Qt;
Comment[hu_HU]=Fájlok letöltése és megosztása a BitTorrent hálózaton keresztül
Comment=Download and share files over BitTorrent
Exec=env TMPDIR=/var/tmp qbittorrent %U
GenericName[hu_HU]=BitTorrent kliens
GenericName=BitTorrent client
Icon=qbittorrent
Keywords=bittorrent;torrent;magnet;download;p2p;
MimeType=application/x-bittorrent;x-scheme-handler/magnet;
Name[hu_HU]=qBittorrent
Name=qBittorrent
StartupNotify=false
StartupWMClass=qbittorrent
Terminal=false
Type=Application
X-Desktop-File-Install-Version=0.26
EDDIG

# ----

tee /home/$felhasznalo/.config/autostart/megasync.desktop <<EDDIG
[Desktop Entry]
Categories=Network;System;
Comment=Easy automated syncing between your computers and your MEGA cloud drive.
Exec=megasync
GenericName=File Synchronizer
Icon=mega
Name=MEGAsync
StartupNotify=false
Terminal=false
TryExec=megasync
Type=Application
Version=1.0
X-Desktop-File-Install-Version=0.26
X-GNOME-Autostart-Delay=60
EDDIG

# ----

tee /home/$felhasznalo/.config/autostart/mozilla-thunderbird.desktop <<EDDIG
[Desktop Entry]
Categories=Network;Email;
Comment=Send and Receive Email
Exec=thunderbird %u
GenericName=Email
Icon=thunderbird
MimeType=message/rfc822;x-scheme-handler/mailto;
Name=Thunderbird
StartupNotify=true
Terminal=false
TryExec=thunderbird
Type=Application
Version=1.0
X-Desktop-File-Install-Version=0.26
EDDIG

# ----

tee /home/$felhasznalo/.config/autostart/org.kde.yakuake.desktop <<EDDIG
[Desktop Entry]
Categories=Qt;KDE;System;TerminalEmulator;
Comment[hu_HU]=A KDE Konsole-ra épülő legördülő terminálemulátor
Comment=A drop-down terminal emulator based on KDE Konsole technology.
Exec=yakuake
GenericName[hu_HU]=Legördülő terminál
GenericName=Drop-down Terminal
Icon=yakuake
Name[hu_HU]=Yakuake
Name=Yakuake
Terminal=false
Type=Application
X-DBUS-ServiceName=org.kde.yakuake
X-DBUS-StartupType=Unique
X-KDE-StartupNotify=false
EDDIG

# ----

tee /home/$felhasznalo/.config/autostart/telegramdesktop.desktop <<EDDIG
[Desktop Entry]
Version=1.0
Name=Telegram Desktop
Comment=Official desktop version of Telegram messaging app
TryExec=telegram-desktop
Exec=telegram-desktop -autostart
Icon=telegram
Terminal=false
StartupWMClass=TelegramDesktop
Type=Application
Categories=Chat;Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/tg;
Keywords=tg;chat;im;messaging;messenger;sms;tdesktop;
X-GNOME-UsesNotifications=true
EDDIG

# ----

tee /home/$felhasznalo/.config/autostart/signal-desktop_signal-desktop.desktop <<EDDIG
[Desktop Entry]
Categories=Network;InstantMessaging;Chat;
Comment=Private messaging from your desktop
Exec=env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/signal-desktop_signal-desktop.desktop /var/lib/snapd/snap/bin/signal-desktop --no-sandbox %U
Icon=/var/lib/snapd/snap/signal-desktop/346/usr/share/icons/hicolor/512x512/apps/signal-desktop.png
MimeType=x-scheme-handler/sgnl;
Name=Signal
StartupWMClass=Signal
Terminal=false
Type=Application
X-SnapInstanceName=signal-desktop
EDDIG

# ----

tee /home/$felhasznalo/.config/autostart/viber.desktop <<EDDIG
[Desktop Entry]
Name=Viber
Comment=Viber VoIP and messenger
Exec=/opt/viber/Viber %u StartMinimized
Icon=/usr/share/pixmaps/viber.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;P2P;
MimeType=x-scheme-handler/viber;
EDDIG



### Vége!

echo ""
echo ""
echo "A script végzett..."
echo ""
echo "Indítsd újra a gépet!"
echo "Utána állítsd még be: színek, numlock, duplakatt"
echo ""
echo ""
