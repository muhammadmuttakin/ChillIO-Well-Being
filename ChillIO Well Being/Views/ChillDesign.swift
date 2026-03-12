import SwiftUI

// MARK: - Brand Colors
extension Color {
    static let chillGreen       = Color(red: 0.42, green: 0.65, blue: 0.55)
    static let chillGreenDark   = Color(red: 0.18, green: 0.38, blue: 0.30)
    static let chillGreenDeep   = Color(red: 0.08, green: 0.22, blue: 0.18)
    static let chillBG          = Color.white
    static let chillText        = Color(red: 0.12, green: 0.12, blue: 0.12)
    static let chillSubtext     = Color(red: 0.45, green: 0.45, blue: 0.45)
    static let chillCard        = Color.white
    static let chillCardDark    = Color(red: 0.13, green: 0.28, blue: 0.22)
}

// MARK: - Design Constants
struct ChillDesign {
    static let cornerRadius: CGFloat = 16
    static let cardCorner: CGFloat   = 12
    static let buttonHeight: CGFloat = 52
    static let horizontalPad: CGFloat = 24
}

// MARK: - Forest Banner
struct ForestBannerView: View {
    var height: CGFloat = 200
    var title: String? = nil
    var titleAlignment: Alignment = .bottomLeading

    var body: some View {
        ZStack(alignment: titleAlignment) {
            Image("ForestBanner")
                .resizable()
                .scaledToFill()
                .frame(height: height)
                .clipped()

            if let title = title {
                Text(title)
                    .font(.custom("HiraMinProN-W6", size: 26))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(ChillDesign.horizontalPad)
            }
        }
        .frame(height: height)
        .clipped()
    }
}
