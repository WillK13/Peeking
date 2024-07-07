//
//  AuthenticationViewModel.swift
//  Peeking
//
//  Created by Will kaminski on 7/7/24.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func startPhoneAuth(phoneNumber: String) async throws -> String {
        return try await AuthenticationManager.shared.startAuth(phoneNumber: phoneNumber)
    }

    func verifyPhoneCode(verificationID: String, smsCode: String) async throws {
        let authDataResult = try await AuthenticationManager.shared.verifyCode(verificationID: verificationID, smsCode: smsCode)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
}
