#!/bin/bash

echo "=================================================="
echo "⚠️  PERINGATAN: Skrip ini akan melakukan FORCE CLEAN"
echo "    pada seluruh cache, config, share, & state KDE Plasma!"
echo "=================================================="
read -p "Lanjutkan proses pembersihan? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo "Dibatalkan."
	exit 1
fi

echo "🚀 Memulai pembersihan total KDE Plasma..."

# --------------------------------------------------
# 1. CACHE & CONFIG UTAMA (Dari Referensi Anda)
# --------------------------------------------------
echo "-> Membersihkan cache dan config utama (referensi)..."
cd ~/ || exit
rm -rf .kde
rm -rf .cache/plasmashell*
rm -rf .cache/org.kde.dirmodel-qml.kcache
rm -rf .cache/kioexec/ .cache/krunner/ .cache/ksycoca5* .cache/ksycoca6*
rm -rf .cache/krunnerbookmarkrunnerfirefoxdbfile.sqlite
rm -rf .cache/kwin*
rm -rf .cache/org.kde.*
rm -rf .config/plasma*
rm -rf .config/kde*

# --------------------------------------------------
# 2. LOCAL SHARE & STATE (Dari Referensi & Filter Aman)
# --------------------------------------------------
echo "-> Membersihkan folder local share dan state KDE..."

# .local/share KDE items
cd ~/.local/share/ || exit
rm -rf dolphin kate kcookiejar kded5 kded6 keyrings klipper kmail2 knewstuff knewstuff3 konsole kscreen ksysguard kwalletd kxmlgui5 plasma_engine_comic plasma plasma_notes org.kde.gwenview baloo kactivitymanagerd krunnerstaterc libkunitconversion plasma-systemmonitor user-places.xbel*

# .local/state KDE items
cd ~/.local/state/ || exit
rm -rf *staterc UserFeedback.org.kde.*

# --------------------------------------------------
# 3. .CONFIG TARGETED CLEANUP (KDE Only)
# --------------------------------------------------
echo "-> Membersihkan sisa file konfigurasi di ~/.config/..."
cd ~/.config/ || exit

# Referensi Anda & file KDE tambahan
rm -rf akonadi* KDE kconf_updaterc baloo* dolphinrc drkonqirc gwenviewrc kmail2rc k*rc katemetainfos
rm -rf bluedevilglobalrc discoverrc kwinoutputconfig.json powermanagementprofilesrc systemmonitorrc konsave/ session/
rm -rf kwin*

echo "--------------------------------------------------"
echo "✅ Force clean KDE selesai dengan sukses!"
echo "👉 Silakan log out lalu log kembali (atau reboot sistem Anda) "
echo "   agar KDE Plasma meregenerasi konfigurasi default yang bersih."
echo "--------------------------------------------------"
