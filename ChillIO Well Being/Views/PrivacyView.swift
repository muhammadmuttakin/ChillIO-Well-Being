import SwiftUI

struct PrivacyView: View {
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
                    
                    Text("Privacy Policy")
                        .font(.custom("HiraMinProN-W6", size: 18))
                        .foregroundColor(.chillText)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 40, height: 40)
                }
                
                // Privacy Info Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.chillGreen)
                        
                        Text("Your Privacy is Safe")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.chillText)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.chillGreen)
                                .padding(.top, 2)
                            Text("The app only stores your name and primary goal.")
                                .font(.system(size: 15))
                                .lineSpacing(4)
                                .foregroundColor(.chillSubtext)
                        }
                        
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.chillGreen)
                                .padding(.top, 2)
                            Text("No other personal data is collected, shared, or sold.")
                                .font(.system(size: 15))
                                .lineSpacing(4)
                                .foregroundColor(.chillSubtext)
                        }
                        
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.chillGreen)
                                .padding(.top, 2)
                            Text("All data is stored locally on your device (offline).")
                                .font(.system(size: 15))
                                .lineSpacing(4)
                                .foregroundColor(.chillSubtext)
                        }
                    }
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
