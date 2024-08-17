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
        
        // Check if user already exists and merge data
        if let existingUser = try? await UserManager.shared.getUser(userId: authDataResult.userId) {
            var user = DBUser(auth: authDataResult)
            user.isProfileSetupComplete = existingUser.isProfileSetupComplete
            user.userType = existingUser.userType
            user.matches = existingUser.matches
            user.likes_you = existingUser.likes_you
            user.bookmarks = existingUser.bookmarks
            try await UserManager.shared.createOrUpdateUser(user: user)
        } else {
            let user = DBUser(auth: authDataResult)
            try await UserManager.shared.createOrUpdateUser(user: user)
        }
    }
    
    func startPhoneAuth(phoneNumber: String) async throws -> String {
        return try await AuthenticationManager.shared.startAuth(phoneNumber: phoneNumber)
    }

    func verifyPhoneCode(verificationID: String, smsCode: String) async throws {
        let authDataResult = try await AuthenticationManager.shared.verifyCode(verificationID: verificationID, smsCode: smsCode)
        
        // Check if user already exists and merge data
        if let existingUser = try? await UserManager.shared.getUser(userId: authDataResult.userId) {
            var user = DBUser(auth: authDataResult)
            user.isProfileSetupComplete = existingUser.isProfileSetupComplete
            user.userType = existingUser.userType
            user.matches = existingUser.matches
            user.likes_you = existingUser.likes_you
            user.bookmarks = existingUser.bookmarks
            try await UserManager.shared.createOrUpdateUser(user: user)
        } else {
            let user = DBUser(auth: authDataResult)
            try await UserManager.shared.createOrUpdateUser(user: user)
        }
    }
}
