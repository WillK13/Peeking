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
    @Binding var showSignInView: Bool
    @Binding var isProfileSetupComplete: Bool

    var body: some View {
        VStack(spacing: 20) {
            if !isCodeSent {
                TextField("Enter your phone number", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)  // Phone pad for phone number input
                    .padding()
                let number = "+1\(phoneNumber)"
                Button(action: {
                    phoneAuthManager.startAuth(phoneNumber: number) { success in
                        guard success else { return }
                        isCodeSent = true
                    }
                }) {
                    Text("Send Verification Code")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                
                Spacer()
                
            } else {
                TextField("Enter your code", text: $verificationCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)  // Number pad for verification code input
                    .padding()
                Button(action: {
                    phoneAuthManager.verifyCode(smsCode: verificationCode) { success in
                        guard success else { return }
                        isVerified = true
                        showVerificationPopup = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showSignInView = false
                            isProfileSetupComplete = false  // Ensure user needs to complete profile setup
                        }
                    }
                }) {
                    Text("Verify Code")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
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
}

struct PhoneAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthView(showSignInView: .constant(true), isProfileSetupComplete: .constant(false))
    }
}
