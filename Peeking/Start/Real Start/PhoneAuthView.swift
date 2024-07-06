//
//  PhoneAuthView.swift
//  Peeking
//
//  Created by Will kaminski on 7/1/24.
//

import SwiftUI
import FirebaseAuth

struct PhoneAuthView: View {
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var isCodeSent: Bool = false
    @ObservedObject private var phoneAuthManager = PhoneAuthManager()
    @State private var isVerified: Bool = false
    @State private var showVerificationPopup: Bool = false
    @State private var errorMessage: String?
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showWelcomeView = false
    @State private var showContentView = false

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
                        .keyboardType(.phonePad)  // Phone pad for phone number input
                        .padding(.top, 200.0)
                    let number = "+1\(phoneNumber)"
                    Button(action: {
                        phoneAuthManager.startAuth(phoneNumber: number) { success in
                            guard success else {
                                errorMessage = "Failed to send verification code."
                                return
                            }
                            isCodeSent = true
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
                    TextField("Enter your code", text: $verificationCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)  // Number pad for verification code input
                        .padding()
                    Spacer()
                    Button(action: {
                        phoneAuthManager.verifyCode(smsCode: verificationCode) { success in
                            guard success else {
                                errorMessage = "Failed to verify code."
                                return
                            }
                            isVerified = true
                            showVerificationPopup = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                viewModel.loadCurrentUser()
                                if viewModel.isProfileCreated {
                                    showContentView = true
                                } else {
                                    showWelcomeView = true
                                }
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
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                self.errorMessage = nil
                            }
                        }
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
        .fullScreenCover(isPresented: $showContentView) {
            ContentView()
        }
    }
}

struct PhoneAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthView(viewModel: ProfileViewModel())
    }
}
