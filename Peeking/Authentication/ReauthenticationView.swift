//
//  ReauthenticationView.swift
//  Peeking
//
//  Created by Will kaminski on 7/8/24.
//

import Foundation
import SwiftUI

struct ReauthenticationView: View {
    @Binding var showReauthenticationView: Bool
    @Binding var showFirstView: Bool
    @StateObject private var viewModel = ReauthenticationViewModel()
    @State private var errorMessage: String?
    @State private var showVerificationCodeInput: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Re-authenticate to Delete Account")
                .font(.title2)
                .padding(.bottom, 20)

            if showVerificationCodeInput {
                TextField("Verification Code", text: $viewModel.smsCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                Button(action: {
                    viewModel.reauthenticateWithPhone { result in
                        switch result {
                        case .success:
                            showFirstView = true
                            showReauthenticationView = false
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("Re-authenticate with Phone")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            } else {
                TextField("Phone Number", text: $viewModel.phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)

                Button(action: {
                    viewModel.phoneNumber = "+1" + viewModel.phoneNumber
                    viewModel.startPhoneReauthentication { result in
                        switch result {
                        case .success:
                            showVerificationCodeInput = true
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("Send Verification Code")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }

            // Apple re-authentication
            SignInWithAppleButtonViewRepresentable(type: .signIn, style: .black)
                .onTapGesture {
                    Task {
                        do {
                            let result = try await SignInAppleHelper().startSignInWithAppleFlow()
                            viewModel.appleSignInResult = result
                            viewModel.reauthenticateWithApple { result in
                                switch result {
                                case .success:
                                    showFirstView = true
                                    showReauthenticationView = false
                                case .failure(let error):
                                    errorMessage = error.localizedDescription
                                }
                            }
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                }
                .frame(width: 250.0, height: 50)
                .cornerRadius(8)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}
