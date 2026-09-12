cask "m14t-touch" do
  version "1.0.3"
  sha256 "851166dfd8b1611ac9ed862718309cdc66e2416bb98f430b07a5cddecf25bc6e"

  url "https://github.com/i4erkasov/m14t-touch-macos/releases/download/v#{version}/M14t-Touch-v#{version}.dmg",
      verified: "github.com/i4erkasov/m14t-touch-macos/"
  name "M14t Touch"
  desc "Touch and stylus input for the Lenovo ThinkVision M14t"
  homepage "https://i4erkasov.github.io/m14t-touch-macos/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "M14t Touch.app"

  # The app is a menu-bar agent that holds the panel's HID device exclusively.
  # Quitting it before the bundle is replaced matters more here than for most
  # apps: a replaced bundle under a live process leaves the device seized by a
  # copy that no longer exists on disk.
  uninstall quit: "com.m14ttouch.app"

  # Only what the app itself writes. `zap` runs solely on `brew uninstall --zap`,
  # so a plain uninstall keeps the settings for a reinstall.
  #   ...Preferences  — every setting, including the calibration
  #   ...Caches, HTTPStorages — created by the update check's URLSession
  zap trash: [
    "~/Library/Caches/com.m14ttouch.app",
    "~/Library/HTTPStorages/com.m14ttouch.app",
    "~/Library/Preferences/com.m14ttouch.app.plist",
  ]

  caveats do
    <<~EOS
      M14t Touch is signed, but not notarized by Apple, so Gatekeeper refuses to
      run it while the quarantine attribute Homebrew applies is still on it:

        xattr -dr com.apple.quarantine "#{appdir}/M14t Touch.app"

      Installing with --no-quarantine avoids that step, on upgrades too:

        brew install --cask --no-quarantine m14t-touch

      The app then needs two permissions in System Settings → Privacy & Security,
      and must be quit and reopened once afterwards for them to take effect:

        Input Monitoring   to read the panel's touches
        Accessibility      to move the pointer and click

      It lives in the menu bar; a grey icon means the panel is not connected.
    EOS
  end
end
