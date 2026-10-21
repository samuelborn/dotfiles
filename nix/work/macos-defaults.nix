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
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      show-recents = false;
      expose-group-apps = true; # AeroSpace: readable Mission Control
    };

    # AeroSpace: one Space across all displays avoids window glitches
    spaces.spans-displays = true;

    finder = {
      AppleShowAllFiles = true;
    };

    screencapture.location = "~/Pictures/Screenshots";
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
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '
  '';
}
