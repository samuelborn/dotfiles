# Regenerate list: flatpak list --app --columns=application | sed 's/$/ \\/' | sort
flatpak install flathub -y \
    org.gtk.Gtk3theme.adw-gtk3 \
    org.gtk.Gtk3theme.adw-gtk3-dark \
    \
    com.discordapp.Discord \
    com.github.jeromerobert.pdfarranger \
    com.calibre_ebook.calibre \
    com.github.tchx84.Flatseal \
    org.chromium.Chromium \
    org.gnome.Loupe \
    org.gnome.Showtime \
    org.gnome.Papers \
    org.gnome.Calendar \
    com.spotify.Client \
    net.ankiweb.Anki \
    org.gimp.GIMP \
    org.signal.Signal \
    org.mozilla.Thunderbird
