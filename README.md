<div align="center">

<h1>GlassPlayer.</h1>

<p>
  <strong>Your music. One beautiful place.</strong>
</p>

<p>
  A native macOS music player built with SwiftUI, designed to bring your music together in a clean, adaptive interface.
</p>

<br>

<p>
  <img src="https://img.shields.io/badge/platform-macOS-20232A?style=flat-square" alt="Platform: macOS">
  <img src="https://img.shields.io/badge/built%20with-SwiftUI-orange?style=flat-square" alt="Built with SwiftUI">
  <img src="https://img.shields.io/badge/status-in%20development-blue?style=flat-square" alt="Status: in development">
</p>

<br>

<p>
  <strong>Minimal by design. Made for macOS.</strong>
</p>

</div>

---

## About

**GlassPlayer** is a native macOS music player project focused on a calm, modern listening experience.

Instead of a crowded interface, GlassPlayer puts your music first: a clear search and library area, an elegant now-playing view, and playback controls that feel at home on the Mac.

The project aims to bring multiple music sources and local audio into one thoughtfully designed app.

## Features

- **Native macOS interface** — Built with SwiftUI and designed around the macOS experience.
- **Adaptive layout** — The interface adjusts to different window sizes.
- **Multiple music sources** — Spotify, SoundCloud, YouTube Music, and local audio, depending on the source integration and its requirements.
- **Now Playing** — Album artwork, track details, playback progress, and volume controls.
- **Playlist and link import** — Import supported playlists or music links.
- **Native menus and shortcuts** — Keep common playback actions close at hand.
- **Spotify account connection** — Sign in through Spotify authorization rather than entering your Spotify password into GlassPlayer.

## The Idea

Music should feel effortless.

GlassPlayer brings a clean interface, useful playback controls, and a macOS-native feel together in one place — without unnecessary visual noise.

## Getting Started

### Requirements

- A Mac running macOS 14 or later.
- Xcode with SwiftUI support.
- A Spotify account for Spotify integration. Spotify Premium may be required for playback through the Spotify Web API.
- [Homebrew](https://brew.sh/) and `yt-dlp` for the optional YouTube Music / SoundCloud integration used by the project.

### Run from Xcode

1. Clone this repository:

   ```bash
   git clone https://github.com/louizmac/GlassPlayer.git
   cd GlassPlayer
   ```

2. Open `GlassPlayer.xcodeproj` in Xcode.
3. Select the `GlassPlayer` scheme and your Mac as the run destination.
4. Configure the required provider settings before using integrations that need credentials.
5. Press **Run** (`⌘R`).

### Optional media tools

If your local project uses `yt-dlp` for supported sources, install it with Homebrew:

```bash
brew install yt-dlp
```

Use third-party music services only in accordance with their terms and applicable copyright rules.

## Tech Stack

- **Swift** — Application logic
- **SwiftUI** — Native macOS interface
- **AVFoundation** — Local and resolved audio playback
- **Spotify Web API** — Account and playback integration
- **yt-dlp** — Optional source resolution for supported links

## Project Status

GlassPlayer is currently in development. Features and setup steps may change, and the project has not yet been presented as a signed, production-ready release.

<div align="center">

<br>

### Your music, without the noise.

<p>
  Designed for macOS.<br>
  Made with simplicity in mind.
</p>

<sub>Created with the assistance of AI tools, including ChatGPT.</sub>

<sub>GlassPlayer is an independent project and is not affiliated with Spotify, SoundCloud, or YouTube.</sub>

</div>
