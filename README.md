# homebrew-m14t-touch

A [Homebrew tap](https://docs.brew.sh/Taps) for
[**M14t Touch**](https://github.com/i4erkasov/m14t-touch-macos) — touch and
stylus input for the Lenovo ThinkVision M14t on macOS.

## Install

```sh
brew tap i4erkasov/m14t-touch
brew install --cask --no-quarantine m14t-touch
```

`--no-quarantine` is not decoration. The app is signed, but not notarized by
Apple — notarization needs a paid Developer ID — and macOS refuses to run
unnotarized code that carries the quarantine attribute Homebrew applies by
default. Without the flag the install succeeds and the app will not open. If you
have already installed it without the flag:

```sh
xattr -dr com.apple.quarantine "/Applications/M14t Touch.app"
```

Use the same flag when upgrading, or the attribute comes back with the new
version.

## After installing

The app needs two permissions, both in **System Settings → Privacy & Security**:

- **Input Monitoring** — to read the panel's touches
- **Accessibility** — to move the pointer and click

Grant both, then **quit and reopen the app**: macOS applies these only to a
freshly started process. It lives in the menu bar; a grey icon means the panel
is not connected or touch is off, and the menu says which.

The [settings guide](https://i4erkasov.github.io/m14t-touch-macos/guide.html)
describes every option.

## Upgrade

```sh
brew update
brew upgrade --cask --no-quarantine m14t-touch
```

Permissions survive an upgrade: every release is signed with the same identity,
and macOS keys those two grants to the signature rather than to the bytes.

## Uninstall

```sh
brew uninstall --cask m14t-touch
```

That removes the app and leaves your settings — calibration included — where
they are, so reinstalling picks up where you left off. To remove those too:

```sh
brew uninstall --zap --cask m14t-touch
```

If you had **Open at login** switched on, macOS may keep showing the app under
System Settings → General → Login Items until you remove it there. Homebrew
cannot clear that entry: it lives in the system's background-task database, not
in a file the cask owns.

## Untap

```sh
brew untap i4erkasov/m14t-touch
```

## How this tap is updated

Publishing a release in the main repository triggers
[`release.yml`](https://github.com/i4erkasov/m14t-touch-macos/blob/main/.github/workflows/release.yml)
there, which reads the new version, downloads the DMG, computes its SHA-256 and
opens a pull request here. Nothing is pushed to `main` unreviewed, and the
checksum in the cask is always the one of the file GitHub is actually serving.
