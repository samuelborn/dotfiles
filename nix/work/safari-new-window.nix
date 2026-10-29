# Default browser that opens every link in a new Safari window.
# Safari itself adds a tab to its front window, which may be on another AeroSpace workspace;
# a new window lands on the focused one.
# Set it as default once: `defaultbrowser safari-new-window`
{ stdenvNoCC, writeText }:
let
  script = writeText "safari-new-window.applescript" ''
    on open location theURL
      tell application "Safari"
        make new document with properties {URL:theURL}
        activate
      end tell
    end open location
  '';
in
# needs /usr/bin tools, so it relies on the sandbox being off (the default on macOS)
stdenvNoCC.mkDerivation {
  name = "safari-new-window";
  dontUnpack = true;
  dontFixup = true;
  installPhase = ''
    app="$out/Applications/Safari New Window.app"
    plist="$app/Contents/Info.plist"
    mkdir -p "$out/Applications"
    /usr/bin/osacompile -o "$app" ${script}
    pb() { /usr/libexec/PlistBuddy -c "$1" "$plist"; }
    pb "Add :CFBundleIdentifier string com.samuelborn.safari-new-window"
    pb "Add :LSUIElement bool true"
    pb "Add :CFBundleURLTypes array"
    pb "Add :CFBundleURLTypes:0 dict"
    pb "Add :CFBundleURLTypes:0:CFBundleURLName string Web URL"
    pb "Add :CFBundleURLTypes:0:CFBundleURLSchemes array"
    pb "Add :CFBundleURLTypes:0:CFBundleURLSchemes:0 string http"
    pb "Add :CFBundleURLTypes:0:CFBundleURLSchemes:1 string https"
    # the plist edits break osacompile's signature
    /usr/bin/codesign --force --sign - "$app"
  '';
}
