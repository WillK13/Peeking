//
//  AuthenticationManager.swift
//  Peeking
//
//  Created by Will kaminski on 7/7/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultModel {
    let userId: String
    let lastLogIn: Date
    let isProfileSetupComplete: Bool
    let userType: Int
    var matches: [String]
    var likesYou: [String]
    var bookmarks: [String]
    
    init(user: FirebaseAuth.User) {
        self.userId = user.uid
        self.lastLogIn = Date()
        self.isProfileSetupComplete = false
        self.userType = -1
        self.matches = []
        self.likesYou = []
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
        
        let userId = user.uid
        // Delete subcollections first
        try await UserManager.shared.deleteSubcollections(userId: userId)
        
        // Delete the user document
        try await Firestore.firestore().collection("users").document(userId).delete()
        print("User document successfully removed!")
        
        // Delete the user account
        try await user.delete()
        print("User account successfully removed!")
    }
    
    func reauthenticateWithApple(tokens: SignInWithAppleResult) async throws {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce)
        try await Auth.auth().currentUser?.reauthenticate(with: credential)
    }
    
    func reauthenticateWithPhone(verificationID: String, smsCode: String) async throws {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: smsCode)
        try await Auth.auth().currentUser?.reauthenticate(with: credential)
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

// MARK: Reauthentication ViewModel

@MainActor
final class ReauthenticationViewModel: ObservableObject {
    @Published var smsCode: String = ""
    @Published var phoneNumber: String = ""
    @Published var verificationID: String = ""
    @Published var appleSignInResult: SignInWithAppleResult?

    func startPhoneReauthentication(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                verificationID = try await AuthenticationManager.shared.startAuth(phoneNumber: phoneNumber)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func reauthenticateWithPhone(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await AuthenticationManager.shared.reauthenticateWithPhone(verificationID: verificationID, smsCode: smsCode)
                try await AuthenticationManager.shared.delete()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func reauthenticateWithApple(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                if let result = appleSignInResult {
                    try await AuthenticationManager.shared.reauthenticateWithApple(tokens: result)
                    try await AuthenticationManager.shared.delete()
                    completion(.success(()))
                } else {
                    completion(.failure(URLError(.badServerResponse)))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
