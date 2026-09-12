cask "m14t-touch" do
  version "1.0.2"
  sha256 "97bad9fb5fa9952336a5d5c8b98b01f627d77f6b6603a0092888d900c65812ec"

  url "https://github.com/i4erkasov/m14t-touch-macos/releases/download/v#{version}/M14t-Touch-v#{version}.dmg"
  name "M14t Touch"
  desc "Touch and stylus input for the Lenovo ThinkVision M14t"
  homepage "https://i4erkasov.github.io/m14t-touch-macos/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "M14t Touch.app"

  # The app is signed, but not notarized — that needs a paid Developer ID — and
  # macOS kills unnotarized code that still carries the quarantine attribute.
  # Homebrew 6 applies that attribute on download and no longer has the
  # `--no-quarantine` flag that used to opt out, so without this the install
  # succeeds and the app cannot open.
  #
  # What quarantine buys — a guarantee that the bytes are the ones the developer
  # published — the `sha256` above already gives, over HTTPS, from the project's
  # own release. What it costs is the whole install. The trade is stated in the
  # caveats rather than made quietly, and notarization is the real fix.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/M14t Touch.app"],
        must_succeed:   false,
        writable_paths: ["M14t Touch.app"],
        writable_base:  :appdir
  end

  # A menu-bar agent that holds the panel's HID device exclusively. Quitting it
  # before the bundle is replaced matters more here than for most apps: a
  # replaced bundle under a live process leaves the device seized by a copy that
  # no longer exists on disk.
  uninstall quit: "com.m14ttouch.app"

  # Only what the app itself writes. `zap` runs solely on `brew uninstall --zap`,
  # so a plain uninstall keeps the settings — calibration included — for a
  # reinstall. Caches and HTTPStorages are the update check's URLSession.
  zap trash: [
    "~/Library/Caches/com.m14ttouch.app",
    "~/Library/HTTPStorages/com.m14ttouch.app",
    "~/Library/Preferences/com.m14ttouch.app.plist",
  ]

  caveats <<~EOS
    M14t Touch is signed, but not notarized by Apple. macOS refuses to run
    unnotarized code that carries the quarantine attribute, and Homebrew 6
    always sets it, so this cask removed it from the installed app. Gatekeeper
    will not vet this app for you; the cask verified its SHA-256 instead.

    Two permissions are needed, both in System Settings → Privacy & Security:

      Input Monitoring   to read the panel's touches
      Accessibility      to move the pointer and click

    Grant both, then quit and reopen the app: macOS applies these only to a
    freshly started process. It lives in the menu bar, and a grey icon means the
    panel is not connected or touch is off — the menu says which.
  EOS
end
