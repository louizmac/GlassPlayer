import Foundation
import SwiftUI

enum MusicSource: String, CaseIterable, Identifiable, Hashable {
    case soundCloud = "SoundCloud"
    case spotify = "Spotify"
    case youtubeMusic = "YouTube Music"
    case local = "On My Mac"

    var id: String { rawValue }

    static let searchableCases: [MusicSource] = [.soundCloud, .spotify, .youtubeMusic]

    var symbol: String {
        switch self {
        case .soundCloud: return "cloud.fill"
        case .spotify: return "waveform"
        case .youtubeMusic: return "play.rectangle.fill"
        case .local: return "folder.fill"
        }
    }
}

struct Track: Identifiable, Hashable {
    let id: String
    let title: String
    let artist: String
    let artworkURL: URL?
    let duration: TimeInterval
    let source: MusicSource
    let webpageURL: URL?
    let spotifyURI: String?
    let localURL: URL?

    init(
        id: String,
        title: String,
        artist: String,
        artworkURL: URL? = nil,
        duration: TimeInterval = 0,
        source: MusicSource,
        webpageURL: URL? = nil,
        spotifyURI: String? = nil,
        localURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.artworkURL = artworkURL
        self.duration = duration
        self.source = source
        self.webpageURL = webpageURL
        self.spotifyURI = spotifyURI
        self.localURL = localURL
    }

    var durationText: String {
        guard duration.isFinite, duration > 0 else { return "" }
        let total = Int(duration.rounded())
        return "\(total / 60):\(String(format: "%02d", total % 60))"
    }
}

extension Color {
    init(hex: UInt, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

struct SpotifyPlaybackSnapshot {
    let isPlaying: Bool
    let progress: TimeInterval
    let duration: TimeInterval
    let uri: String?
}
