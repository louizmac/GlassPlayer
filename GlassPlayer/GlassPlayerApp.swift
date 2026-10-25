import SwiftUI
import AppKit

@main
struct GlassPlayerApp: App {
    @StateObject private var model = PlayerViewModel()

    var body: some Scene {
        WindowGroup("GlassPlayer") {
            ContentView()
                .environmentObject(model)
                .preferredColorScheme(.dark)
        }
        .defaultSize(width: 1120, height: 760)
        .windowStyle(.automatic)
        .commands {
            GlassPlayerCommands(model: model)
        }
    }
}

struct GlassPlayerCommands: Commands {
    @ObservedObject var model: PlayerViewModel

    var body: some Commands {
        CommandGroup(replacing: .appSettings) {
            Button("Settings…") {
                NotificationCenter.default.post(name: .glassPlayerShowSettings, object: nil)
            }
            .keyboardShortcut(",", modifiers: [.command])
        }

        CommandGroup(after: .newItem) {
            Button("Import Music…") {
                NotificationCenter.default.post(name: .glassPlayerShowImport, object: nil)
            }
            .keyboardShortcut("o", modifiers: [.command, .shift])
        }

        CommandGroup(after: .textEditing) {
            Divider()
            Button("Search Music") {
                NotificationCenter.default.post(name: .glassPlayerFocusSearch, object: nil)
            }
            .keyboardShortcut("f", modifiers: [.command])
        }

        CommandMenu("Playback") {
            Button(model.isPlaying ? "Pause" : "Play") {
                Task { await model.togglePlayback() }
            }
            .keyboardShortcut(.space, modifiers: [])
            .disabled(model.currentTrack == nil && model.results.isEmpty)

            Divider()

            Button("Previous Track") {
                Task { await model.previousTrack() }
            }
            .keyboardShortcut(.leftArrow, modifiers: [.command, .option])
            .disabled(model.results.isEmpty && model.currentTrack == nil)

            Button("Next Track") {
                Task { await model.nextTrack() }
            }
            .keyboardShortcut(.rightArrow, modifiers: [.command, .option])
            .disabled(model.results.isEmpty)
        }

        CommandMenu("Source") {
            ForEach(MusicSource.allCases) { source in
                Button {
                    model.selectSource(source)
                } label: {
                    if model.selectedSource == source {
                        Label(source.rawValue, systemImage: "checkmark")
                    } else {
                        Text(source.rawValue)
                    }
                }
            }
        }
    }
}

extension Notification.Name {
    static let glassPlayerShowSettings = Notification.Name("GlassPlayer.ShowSettings")
    static let glassPlayerShowImport = Notification.Name("GlassPlayer.ShowImport")
    static let glassPlayerFocusSearch = Notification.Name("GlassPlayer.FocusSearch")
}
