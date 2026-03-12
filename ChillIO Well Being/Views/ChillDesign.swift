//
//  ChillDesign.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

// MARK: - Brand Colors
extension Color {
    static let chillGreen       = Color(red: 0.42, green: 0.65, blue: 0.55)
    static let chillGreenDark   = Color(red: 0.18, green: 0.38, blue: 0.30)
    static let chillGreenDeep   = Color(red: 0.08, green: 0.22, blue: 0.18)
    static let chillBG          = Color(red: 0.97, green: 0.97, blue: 0.96)
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

// MARK: - Forest Banner Gradient
struct ForestBannerView: View {
    var height: CGFloat = 200
    var title: String? = nil
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Forest gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.20, blue: 0.15),
                    Color(red: 0.12, green: 0.35, blue: 0.25),
                    Color(red: 0.25, green: 0.52, blue: 0.38),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Silhouette trees (decorative)
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(0..<12, id: \.self) { i in
                    TreeSilhouette(height: CGFloat.random(in: 60...120))
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .opacity(0.35)
            
            // Birds
            HStack(spacing: 6) {
                ForEach(0..<4, id: \.self) { _ in
                    Text("'")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                        .rotationEffect(.degrees(-10))
                }
            }
            .padding(.bottom, height * 0.6)
            .padding(.leading, 40)
            
            if let title = title {
                Text(title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .padding(ChillDesign.horizontalPad)
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 0))
    }
}

struct TreeSilhouette: View {
    var height: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Triangle()
                .fill(Color(red: 0.05, green: 0.18, blue: 0.12))
                .frame(width: 28, height: height)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.closeSubpath()
        }
    }
}
