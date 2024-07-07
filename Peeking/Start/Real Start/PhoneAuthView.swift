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
                    }
                    Spacer()
                }

                if !isCodeSent {
                    TextField("Enter your phone number", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 350.0)
                        .keyboardType(.phonePad)
                        .padding(.top, 200.0)
                    
                    Button(action: {
                        Task {
                            do {
                                try await phoneHelper.startSignInWithPhoneFlow(phoneNumber: "+1\(phoneNumber)")
                                isCodeSent = true
                            } catch {
                                errorMessage = "Failed to send verification code."
                            }
                        }
                    }) {
                        Text("Send Verification Code")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                } else {
                    TextField("Enter your code", text: $phoneHelper.smsCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                    Spacer()
                    Button(action: {
                        Task {
                            do {
                                try await authViewModel.verifyPhoneCode(verificationID: phoneHelper.verificationID ?? "", smsCode: phoneHelper.smsCode)
                                // After verification, check if the user profile is created
                                if let user = try? AuthenticationManager.shared.getAuthenticatedUser(),
                                   let dbUser = try? await UserManager.shared.getUser(userId: user.userId) {
                                    if dbUser.isProfileSetupComplete == true {
                                        showMainView = true
                                    } else {
                                        showWelcomeView = true
                                    }
                                }
                            } catch {
                                errorMessage = "Failed to verify code."
                            }
                        }
                    }) {
                        Text("Verify Code")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }

                if showVerificationPopup {
                    Text("Phone number verified successfully!")
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
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

struct PhoneAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthView(authViewModel: AuthenticationViewModel())
    }
}
