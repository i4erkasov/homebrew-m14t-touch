# homebrew-m14t-touch

A [Homebrew tap](https://docs.brew.sh/Taps) for
[**M14t Touch**](https://github.com/i4erkasov/m14t-touch-macos) — touch and
stylus input for the Lenovo ThinkVision M14t on macOS 13 or later, Apple Silicon
and Intel.

## Install

```sh
brew tap i4erkasov/m14t-touch
brew trust i4erkasov/m14t-touch
brew install --cask m14t-touch
```

The middle command is not optional and not ours: Homebrew 6 refuses to load a
cask from a tap outside `Homebrew/*` until you say you trust it. It is a
one-time answer per tap, kept in `~/.homebrew/trust.json`.

## After installing

The app needs two permissions, both in **System Settings → Privacy & Security**:

- **Input Monitoring** — to read the panel's touches
- **Accessibility** — to move the pointer and click

Grant both, then **quit and reopen the app**: macOS applies these only to a
freshly started process. It lives in the menu bar; a grey icon means the panel
is not connected or touch is off, and the menu says which.

The [settings guide](https://i4erkasov.github.io/m14t-touch-macos/guide.html)
describes every option.

## About Gatekeeper

M14t Touch is signed, but **not notarized** by Apple — notarization requires a
paid Developer ID. macOS kills unnotarized code that carries the quarantine
attribute, Homebrew 6 always applies that attribute, and the `--no-quarantine`
flag that used to opt out no longer exists. Installed as-is, the app would never
open.

So the cask clears the attribute from the app it just installed. You should know
what that means rather than find it in the source later:

- **Gatekeeper does not vet this app.** Nobody at Apple has looked at it.
- What Gatekeeper would have guaranteed — that the bytes are the ones the
  developer published — the cask guarantees differently: it checks the download
  against a SHA-256 pinned in this repository, fetched over HTTPS from the
  project's own GitHub release.
- Notarization is the real fix, and it is on the project's list.

Homebrew offers no flag to keep the attribute, so if you would rather handle
Gatekeeper yourself, skip the cask: download the DMG from
[Releases](https://github.com/i4erkasov/m14t-touch-macos/releases) and follow the
note inside it.

## Upgrade

```sh
brew update
brew upgrade --cask m14t-touch
```

Permissions survive an upgrade, and a move: every release is signed with the
same identity, and macOS keys Input Monitoring and Accessibility to the
signature and bundle identifier rather than to the bytes or the path.

## Uninstall

```sh
brew uninstall --cask m14t-touch
```

That removes the app and leaves your settings — calibration included — where
they are, so reinstalling picks up where you left off. To remove those too:

```sh
brew uninstall --zap --cask m14t-touch
```

If you had **Open at login** switched on, macOS may keep listing the app under
System Settings → General → Login Items until you remove it there. Homebrew
cannot clear that: it lives in the system's background-task database, registered
through `SMAppService`, not in a file this cask owns.

## Untap

```sh
brew untap i4erkasov/m14t-touch
```

## How this tap is updated

Publishing a release in the main repository runs
[`release.yml`](https://github.com/i4erkasov/m14t-touch-macos/blob/main/.github/workflows/release.yml)
there, which reads the new version, downloads the DMG GitHub is actually
serving, computes its SHA-256, and opens a pull request here. Nothing lands on
`main` unreviewed, and the checksum is never copied from a local build.
