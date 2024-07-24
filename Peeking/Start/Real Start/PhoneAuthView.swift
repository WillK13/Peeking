//
//  PhoneAuthView.swift
//  Peeking
//
//  Created by Will kaminski on 7/1/24.
//

import SwiftUI

struct PhoneAuthView: View {
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @StateObject private var phoneHelper = SignInWithPhoneHelper.shared
    @State private var isCodeSent: Bool = false
    @State private var showVerificationPopup: Bool = false
    @State private var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode
    @State private var showWelcomeView = false
    @State private var showMainView = false
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State private var isVerified = false
    
    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.top, 20)

                Spacer()
                
                Text(isCodeSent ? "Enter Verification Code" : "Enter your Phone Number")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                
                VStack(spacing: 20) {
                    if !isCodeSent {
                        CustomTextField1(text: $phoneNumber, placeholder: "Phone Number", keyboardType: .phonePad)
                        
                        CustomButton(action: {
                            Task {
                                do {
                                    try await phoneHelper.startSignInWithPhoneFlow(phoneNumber: "+1\(phoneNumber)")
                                    withAnimation {
                                        isCodeSent = true
                                    }
                                } catch {
                                    withAnimation {
                                        errorMessage = "Failed to send verification code."
                                    }
                                }
                            }
                        }, title: "Send Verification Code", color: .white)
                    } else {
                        CustomTextField1(text: $phoneHelper.smsCode, placeholder: "Verification Code", keyboardType: .numberPad)
                        
                        CustomButton(action: {
                            Task {
                                do {
                                    try await authViewModel.verifyPhoneCode(verificationID: phoneHelper.verificationID ?? "", smsCode: phoneHelper.smsCode)
                                    withAnimation {
                                        isVerified = true
                                        showVerificationPopup = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        Task {
                                            if let user = try? AuthenticationManager.shared.getAuthenticatedUser(),
                                               let dbUser = try? await UserManager.shared.getUser(userId: user.userId) {
                                                if dbUser.isProfileSetupComplete == true {
                                                    showMainView = true
                                                } else {
                                                    showWelcomeView = true
                                                }
                                            }
                                        }
                                    }
                                } catch {
                                    withAnimation {
                                        isVerified = false
                                        errorMessage = "Failed to verify code."
                                    }
                                }
                            }
                        }, title: "Verify Code", color: .white)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                if let errorMessage = errorMessage {
                    ErrorView(errorMessage: errorMessage)
                }

                if showVerificationPopup {
                    VerificationSuccessView(isVerified: isVerified)
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showWelcomeView) {
            Welcome()
        }
        .fullScreenCover(isPresented: $showMainView) {
            ContentView()
        }
    }
}

struct CustomTextField1: View {
    @Binding var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 5)
            TextField(placeholder, text: $text)
                .padding()
                .keyboardType(keyboardType)
        }
        .frame(height: 50)
    }
}

struct CustomButton: View {
    var action: () -> Void
    var title: String
    var color: Color
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(10)
                .shadow(radius: 5)
                .scaleEffect(1.1)
        }
        .animation(.easeInOut(duration: 0.2), value: 1.1)
    }
}

struct ErrorView: View {
    var errorMessage: String
    
    var body: some View {
        Text(errorMessage)
            .foregroundColor(.red)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.easeInOut(duration: 0.5), value: errorMessage)
    }
}

struct VerificationSuccessView: View {
    var isVerified: Bool
    
    var body: some View {
        VStack {
            if isVerified {
                Text("Phone number verified successfully!")
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.5), value: isVerified)
            } else {
                Text("Verification failed. Please try again.")
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.5), value: isVerified)
            }
        }
    }
}

struct PhoneAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthView(authViewModel: AuthenticationViewModel())
    }
}
