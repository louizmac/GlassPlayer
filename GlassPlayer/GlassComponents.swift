import SwiftUI

struct GlassPanelModifier: ViewModifier {
    var cornerRadius: CGFloat = 24

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.16),
                                .white.opacity(0.055),
                                .white.opacity(0.09)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .shadow(color: .black.opacity(0.14), radius: 22, x: 0, y: 10)
    }
}

extension View {
    func glassPanel(cornerRadius: CGFloat = 24) -> some View {
        modifier(GlassPanelModifier(cornerRadius: cornerRadius))
    }
}

struct ArtworkView: View {
    let url: URL?
    var cornerRadius: CGFloat = 14

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .empty, .failure:
                placeholder
            @unknown default:
                placeholder
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: 0x202229))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(.white.opacity(0.075), lineWidth: 1)
        }
        .accessibilityLabel("Album artwork")
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0x30343B), Color(hex: 0x191B20)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "waveform")
                .font(.system(size: 26, weight: .regular))
                .foregroundStyle(.white.opacity(0.42))
        }
    }
}

struct PlayerIconButton: View {
    let symbol: String
    var size: CGFloat = 16
    var diameter: CGFloat = 44
    var prominent = false
    var disabled = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: size, weight: .semibold))
                .foregroundStyle(disabled ? .white.opacity(0.25) : .white.opacity(0.92))
                .frame(width: diameter, height: diameter)
                .background {
                    Circle()
                        .fill(prominent ? Color.white.opacity(0.16) : Color.white.opacity(0.045))
                }
                .overlay {
                    Circle().strokeBorder(.white.opacity(prominent ? 0.16 : 0.08), lineWidth: 1)
                }
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .help(symbolAccessibilityLabel)
    }

    private var symbolAccessibilityLabel: String {
        switch symbol {
        case "play.fill": return "Play"
        case "pause.fill": return "Pause"
        case "backward.end.fill": return "Previous track"
        case "forward.end.fill": return "Next track"
        default: return symbol
        }
    }
}
