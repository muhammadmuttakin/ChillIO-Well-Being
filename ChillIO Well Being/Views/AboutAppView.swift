import SwiftUI

struct AboutAppView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.chillText)
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    
                    Spacer()
                    
                    Text("About chill.io")
                        .font(.custom("HiraMinProN-W6", size: 18))
                        .foregroundColor(.chillText)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 40, height: 40)
                }
                
                // About Info Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.chillGreen)
                        
                        Text("Our Mission")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.chillText)
                    }
                    
                    Text("**chill.io** was created to help Gen Z and Millennials who often struggle with managing stress and anxiety in their daily lives.\n\nOur goal is to bring you peace of mind through a curated selection of relaxing audio content.")
                        .font(.system(size: 15))
                        .lineSpacing(4)
                        .foregroundColor(.chillSubtext)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 4)
                
                // Audio Sources Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        
                        Text("Audio Sources")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.chillText)
                    }
                    
                    Text("In the current version, our collection of relaxation audio is sourced from various YouTube channels and other audio providers on the internet. We have carefully selected the best audio to help you feel calm and at ease.")
                        .font(.system(size: 15))
                        .lineSpacing(4)
                        .foregroundColor(.chillSubtext)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 4)
            }
            .padding(.horizontal, ChillDesign.horizontalPad)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background(Color.chillBG.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}
