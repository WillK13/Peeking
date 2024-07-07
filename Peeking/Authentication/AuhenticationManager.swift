//
//  AuhenticationManager.swift
//  Peeking
//
//  Created by Will kaminski on 7/7/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultModel {
    let userId: String
    let dateCreated: Date
    let isProfileSetupComplete: Bool
    let userType: Int
    var matches: [String]
    var likesYou: [String]
    var chats: [String]
    var bookmarks: [String]
    
    init(user: User) {
        self.userId = user.uid
        self.dateCreated = Date()
        self.isProfileSetupComplete = false
        self.userType = -1
        self.matches = []
        self.likesYou = []
        self.chats = []
        self.bookmarks = []
    }
}

enum AuthProviderOption: String {
    case apple = "apple.com"
    case phone = "phone"
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
        
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        print(providers)
        return providers
    }
        
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        try await user.delete()
        
        do {
            if let userId = Auth.auth().currentUser?.uid {
                try await Firestore.firestore().collection("users").document(userId).delete()
                print("Document successfully removed!")
            }
        } catch {
          print("Error removing document: \(error)")
        }
    }
}

// MARK: SIGN IN SSO

extension AuthenticationManager {
        
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

// MARK: SIGN IN PHONE

extension AuthenticationManager {
    
    func startAuth(phoneNumber: String) async throws -> String {
        do {
            let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
            return verificationID
        } catch {
            print("Error starting auth for phone number \(phoneNumber): \(error.localizedDescription)")
            throw error
        }
    }
    
    @discardableResult
    func verifyCode(verificationID: String, smsCode: String) async throws -> AuthDataResultModel {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: smsCode)
        do {
            let authDataResult = try await Auth.auth().signIn(with: credential)
            print("Sign-in successful for user ID: \(authDataResult.user.uid)")
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            print("Error verifying code \(smsCode) with verification ID \(verificationID): \(error.localizedDescription)")
            throw error
        }
    }
}
