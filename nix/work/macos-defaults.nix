{ config, ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      "com.apple.keyboard.fnState" = true; # F1-F12 without Fn
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      show-recents = false;
      expose-group-apps = true; # AeroSpace: readable Mission Control
      mru-spaces = false; # AeroSpace: keep Spaces in a fixed order
    };

    # AeroSpace: one Space across all displays avoids window glitches
    spaces.spans-displays = true;

    # AeroSpace does the tiling; stop macOS from fighting it
    WindowManager = {
      EnableStandardClickToShowDesktop = false; # clicking a gap would hide all windows
      EnableTilingByEdgeDrag = false;
      EnableTopTilingByEdgeDrag = false;
      EnableTiledWindowMargins = false;
    };

    finder = {
      AppleShowAllFiles = true;
    };

    screencapture = {
      location = "~/Pictures/Screenshots";
      disable-shadow = true;
    };
  };

  # Free Ctrl+arrows for tmux/nvim pane navigation: disable Mission Control (32),
  # App Exposé (33) and Space switching (79, 81). -dict-add keeps other hotkeys.
  system.activationScripts.postActivation.text = ''
    sudo -u ${config.system.primaryUser} bash -c '
      for spec in "32 126" "33 125" "79 123" "81 124"; do
        set -- $spec
        defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add $1 \
          "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>$2</integer><integer>8650752</integer></array><key>type</key><string>standard</string></dict></dict>"
      done
      # F5 reloads in Safari (\UF708 = F5). Global domain: Safari is sandboxed.
      defaults write -g NSUserKeyEquivalents -dict-add "Reload Page" "\UF708"
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '
  '';
}
