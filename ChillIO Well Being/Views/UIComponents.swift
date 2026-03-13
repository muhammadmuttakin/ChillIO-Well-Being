import SwiftUI

// MARK: - Primary Button
struct ChillButton: View {
    let title: String
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: ChillDesign.buttonHeight)
                .background(isDisabled ? Color.chillGreen.opacity(0.5) : Color.chillGreen)
                .clipShape(Capsule())
        }
        .disabled(isDisabled)
    }
}

// MARK: - Back Button
struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.chillText)
                .frame(width: 36, height: 36)
                .background(Color.gray.opacity(0.12))
                .clipShape(Circle())
        }
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    var isSelected: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isSelected ? .white : .chillText)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.chillGreen : Color.white)
                .overlay(
                    Capsule().stroke(Color.gray.opacity(0.25), lineWidth: 1)
                )
                .clipShape(Capsule())
        }
    }
}

// MARK: - Audio Row Card
struct AudioRowCard: View {
    let item: AudioItem
    var isDark: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Thumbnail — icon by audio category
                RoundedRectangle(cornerRadius: 8)
                    .fill(isDark ? Color.chillCardDark : Color.gray.opacity(0.15))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: item.category.iconName)
                            .font(.system(size: 24))
                            .foregroundColor(isDark ? .white.opacity(0.7) : .chillGreen)
                    )
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(item.type)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(isDark ? .white.opacity(0.6) : .chillSubtext)
                    Text(item.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(isDark ? .white : .chillText)
                    Text(item.description)
                        .font(.system(size: 12))
                        .foregroundColor(isDark ? .white.opacity(0.5) : .chillSubtext)
                }
                Spacer()
                
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(isDark ? .white.opacity(0.6) : .chillGreen)
            }
            .padding(14)
            .background(isDark ? Color.chillCardDark : Color.chillCard)
            .cornerRadius(ChillDesign.cardCorner)
            .overlay(
                RoundedRectangle(cornerRadius: ChillDesign.cardCorner)
                    .stroke(isDark ? Color.clear : Color.gray.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Profile Avatar
struct ProfileAvatar: View {
    var image: UIImage?
    var initials: String = "?"
    var size: CGFloat = 80
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.chillGreen)
                .frame(width: size, height: size)
            
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Text(initials)
                    .font(.system(size: size * 0.35, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.dismiss) var dismiss
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let edited = info[.editedImage] as? UIImage {
                parent.selectedImage = edited
            } else if let original = info[.originalImage] as? UIImage {
                parent.selectedImage = original
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Waveform Visualizer
struct WaveformView: View {
    var isPlaying: Bool
    @State private var animating = false
    
    let barCount = 40
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<barCount, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 4, height: barHeight(for: i))
                    .animation(
                        isPlaying
                        ? Animation.easeInOut(duration: Double.random(in: 0.3...0.7))
                              .repeatForever(autoreverses: true)
                              .delay(Double(i) * 0.03)
                        : .default,
                        value: animating
                    )
            }
        }
        .onChange(of: isPlaying) { _, playing in
            animating = playing
        }
    }
    
    private func barHeight(for index: Int) -> CGFloat {
        let base: CGFloat = 8
        let max: CGFloat  = 48
        if animating {
            return CGFloat.random(in: base...max)
        } else {
            // Static pattern
            let pattern: [CGFloat] = [10,18,30,42,48,38,22,14,20,34,46,40,26,16,12,24,36,44,32,18]
            return pattern[index % pattern.count]
        }
    }
}
