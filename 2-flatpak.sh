flatpak config --set extra-languages "de"

# Regenerate list: flatpak list --app --columns=application | sed 's/$/ \\/' | sort
flatpak install flathub -y \
    org.gtk.Gtk3theme.adw-gtk3 \
    org.gtk.Gtk3theme.adw-gtk3-dark \
    \
    com.discordapp.Discord \
    com.github.jeromerobert.pdfarranger \
    com.calibre_ebook.calibre \
    com.github.tchx84.Flatseal \
    com.mattjakeman.ExtensionManager \
    com.spotify.Client \
    net.ankiweb.Anki \
    org.gimp.GIMP \
    org.signal.Signal \
    org.mozilla.Thunderbird
