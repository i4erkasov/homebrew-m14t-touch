# What it would take to go into homebrew-cask

This tap exists because the cask cannot go into
[Homebrew/homebrew-cask](https://github.com/Homebrew/homebrew-cask) yet. Not
"has not been submitted" — would be rejected, for reasons that are written down
and checkable. Here they are, with where this project actually stands, measured
on 2026-09-12.

## Blocking

### 1. Gatekeeper

> "apps, installers and other executable artefacts that Gatekeeper can assess
> must pass Homebrew's Gatekeeper checks and must not require System Integrity
> Protection or Gatekeeper to be disabled or bypassed."
> — [Acceptable Casks](https://docs.brew.sh/Acceptable-Casks)

```
$ spctl -a -vv -t exec "/Applications/M14t Touch.app"
/Applications/M14t Touch.app: rejected
origin=M14t Touch Local
```

The app is signed with a self-signed certificate and not notarized, so
Gatekeeper rejects it, and this cask removes the quarantine attribute to get
around that. Both halves are disqualifying on their own.

**The fix is notarization, and it is the only one.** A Developer ID certificate
costs $99 a year; `scripts/make-dmg.sh` already notarizes and staples when it
finds one, so the change is administrative rather than technical. With a
notarized build, `spctl` accepts, the `postflight_steps` stanza comes out, and
this section disappears.

### 2. Notability

> "at least 30 forks, 30 watchers or 75 stars" — or "at least 90 forks, 90
> watchers or 225 stars for a self-submission"
> — [Package Acceptance Policy](https://docs.brew.sh/Package-Acceptance-Policy)

A submission by the repository's owner is a self-submission, so the second row
is the one that applies:

| | required | actual |
|---|---:|---:|
| stars | 225 | 1 |
| forks | 90 | 0 |
| watchers | 90 | 0 |

Nothing about the code changes this. It is a driver for one discontinued
portable monitor; whether it ever reaches those numbers is not a thing to
engineer.

### 3. Repository age

> "A code repository less than 30 days old is normally not eligible"

Created 2026-09-09. Eligible from 2026-10-09 onwards.

### 4. It is a fork

`i4erkasov/m14t-touch-macos` is a fork of `talesmousinho/m14t-touch-macos`.
Homebrew's policy on a fork replacing the project it came from asks for either
an official hand-over or adoption by multiple major distributions. Neither has
happened, so a submission would have to be argued rather than filed — or the
repository would have to stop being a fork.

## Already satisfied

- `brew audit --cask --strict --online m14t-touch` — passes.
- `brew style` — passes, no offences.
- A `livecheck` stanza, so the version can be tracked automatically.
- A download published by the developer, over HTTPS, pinned by SHA-256.
- A homepage that explains the project, independent of Homebrew.
- An MIT licence, and a maintained repository.
- A `zap` stanza that removes only what the app itself writes.

## Worth fixing regardless

- **`CFBundleShortVersionString` is `v1.0.3`, with the `v`.** It comes straight
  from `git describe`. Every other tool in the ecosystem expects `1.0.3`, and
  the cask's `version` therefore does not match the bundle's; `brew audit` does
  not object today, but the stricter checks used for new casks compare them.
  Fixing it means stripping the prefix in `scripts/package-app.sh`.
