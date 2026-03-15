import SwiftUI

struct HelpSupportView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack() {
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
                    
                    Text("Help & Support")
                        .font(.custom("HiraMinProN-W6", size: 18))
                        .foregroundColor(.chillText)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 40, height: 40)
                }
                
                // Disclaimer Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.chillGreen)
                        
                        Text("Important Notice")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.chillText)
                    }
                    
                    Text("chill.io is designed to help you feel more relaxed, manage everyday stress, and ease feelings of anxiety.\n\nPlease keep in mind that this app is **not intended** as a medical diagnostic tool or a substitute for professional mental health treatment.")
                        .font(.system(size: 15))
                        .lineSpacing(4)
                        .foregroundColor(.chillSubtext)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 4)
                
                // Emergency Hotline Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)
                        
                        Text("Need Immediate Help?")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.chillText)
                    }
                    
                    Text("If you are going through a difficult time, experiencing an emotional crisis, or need professional support for your mental health, please don't hesitate to reach out. You are not alone.")
                        .font(.system(size: 15))
                        .lineSpacing(4)
                        .foregroundColor(.chillSubtext)
                    
                    Button(action: {
                        if let url = URL(string: "tel://+628113855472") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "phone.arrow.up.right")
                                .font(.system(size: 16, weight: .bold))
                            Text("Call +62 811 3855 472")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.orange)
                        .cornerRadius(12)
                    }
                    .padding(.top, 4)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 4)
                
                // App Support Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.chillGreen)
                        
                        Text("App Support")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.chillText)
                    }
                    
                    Text("Have a question, technical issue, or suggestion about chill.io? Our team is happy to help.")
                        .font(.system(size: 15))
                        .lineSpacing(4)
                        .foregroundColor(.chillSubtext)
                    
                    Button(action: {
                        if let url = URL(string: "https://wa.me/628000000000") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "message.fill")
                                .font(.system(size: 15, weight: .medium))
                            Text("Chat Us (+62 8xxx xxx)")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.chillGreen)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.chillGreen.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.top, 4)
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
