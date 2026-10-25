import AppKit
import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: PlayerViewModel
    @Environment(\.dismiss) private var dismiss
    @AppStorage("spotifyClientID") private var spotifyClientID = ""
    @AppStorage("autoplayNext") private var autoplayNext = true
    @AppStorage("launchSpotify") private var launchSpotify = true
    @AppStorage("rememberVolume") private var rememberVolume = true
    @AppStorage("ambientGlow") private var ambientGlow = true
    @State private var isConnecting = false
    @State private var copiedRedirect = false

    private let redirectURI = "glassplayer://spotify-callback"

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Settings")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    Text("Accounts, playback and appearance")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.52))
                }
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.76))
                        .frame(width: 30, height: 30)
                        .background(.white.opacity(0.09), in: Circle())
                }.buttonStyle(.plain)
            }
            .padding(.bottom, 20)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    sectionTitle("ACCOUNTS")
                    spotifyCard
                    VStack(alignment: .leading, spacing: 5) {
                        Text("YouTube Music and SoundCloud")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Search and playback use yt-dlp installed on your Mac. No sign-in is requested by GlassPlayer for these sources.")
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.56))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 16))

                    sectionTitle("PLAYBACK")
                    settingRow("Autoplay next track", description: "Move to the next result when a local or streamed track ends") {
                        Toggle("Autoplay", isOn: $autoplayNext).labelsHidden().tint(Color(hex: 0x34C759))
                    }
                    settingRow("Open Spotify when needed", description: "Launch Spotify if no playback device is available") {
                        Toggle("Launch Spotify", isOn: $launchSpotify).labelsHidden().tint(Color(hex: 0x34C759))
                    }
                    settingRow("Remember volume", description: "Start at the volume you last used") {
                        Toggle("Remember volume", isOn: $rememberVolume).labelsHidden().tint(Color(hex: 0x34C759))
                    }

                    sectionTitle("APPEARANCE")
                    settingRow("Ambient glow", description: "Softly blurred colour behind the glass panels") {
                        Toggle("Ambient glow", isOn: $ambientGlow).labelsHidden().tint(Color(hex: 0x34C759))
                    }

                    Text("GlassPlayer is an independent project. Spotify sign-in is handled by Spotify's authorization page; the refresh token is stored in macOS Keychain.")
                        .font(.system(size: 10.5))
                        .foregroundStyle(.white.opacity(0.42))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 1)
                }
                .padding(.bottom, 8)
            }
        }
        .padding(28)
        .background(Color(hex: 0x17171F))
        .task { await model.updateSpotifyConnectionState() }
    }

    private var spotifyCard: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(spacing: 13) {
                ZStack {
                    Circle().fill(Color(hex: 0x1DB954).opacity(0.16))
                    Image(systemName: "waveform")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(Color(hex: 0x6DE39B))
                }
                .frame(width: 45, height: 45)
                VStack(alignment: .leading, spacing: 3) {
                    Text(model.spotifyConnected ? (model.spotifyAccountName.isEmpty ? "Spotify connected" : model.spotifyAccountName) : "Spotify")
                        .font(.system(size: 14, weight: .semibold))
                    Text(model.spotifyConnected ? "Connected through Spotify OAuth" : "Search tracks and control a Spotify device")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.52))
                }
                Spacer()
                Button {
                    if model.spotifyConnected {
                        model.disconnectSpotify()
                    } else {
                        connect()
                    }
                } label: {
                    HStack(spacing: 7) {
                        if isConnecting { ProgressView().controlSize(.small).tint(.white) }
                        Text(model.spotifyConnected ? "Sign out" : "Connect")
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 9)
                    .background(.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(isConnecting || (!model.spotifyConnected && spotifyClientID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("SPOTIFY CLIENT ID")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white.opacity(0.46))
                TextField("Paste your Spotify Client ID", text: $spotifyClientID)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
                    .padding(11)
                    .background(.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 11))
                    .overlay(RoundedRectangle(cornerRadius: 11).stroke(.white.opacity(0.075), lineWidth: 1))
            }

            HStack(alignment: .center, spacing: 8) {
                Text("Redirect URI: \(redirectURI)")
                    .font(.system(size: 10.5, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.54))
                    .lineLimit(1)
                    .textSelection(.enabled)
                Spacer(minLength: 4)
                Button {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(redirectURI, forType: .string)
                    copiedRedirect = true
                } label: {
                    Image(systemName: copiedRedirect ? "checkmark" : "doc.on.doc")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.72))
                }
                .buttonStyle(.plain)
                .help("Copy redirect URI")
            }
            Text("Playback through Spotify requires a Premium account and an available Spotify device. Add this exact redirect URI in your Spotify Developer Dashboard.")
                .font(.system(size: 10.5))
                .foregroundStyle(.white.opacity(0.48))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(15)
        .background(.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 17))
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(.white.opacity(0.07), lineWidth: 1))
    }

    private func connect() {
        isConnecting = true
        Task {
            await model.connectSpotify(clientID: spotifyClientID)
            isConnecting = false
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 10, weight: .bold))
            .tracking(1.2)
            .foregroundStyle(.white.opacity(0.44))
            .padding(.bottom, -10)
    }

    private func settingRow<Trailing: View>(
        _ title: String,
        description: String,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 13, weight: .medium))
                Text(description)
                    .font(.system(size: 10.5))
                    .foregroundStyle(.white.opacity(0.48))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 6)
            trailing()
        }
    }
}
