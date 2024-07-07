//
//  SignInWithPhoneHelper.swift
//  Peeking
//
//  Created by Will kaminski on 7/7/24.
//

import Foundation
import FirebaseAuth

struct SignInWithPhoneResult {
    let verificationID: String
    let smsCode: String
}

@MainActor
final class SignInWithPhoneHelper: ObservableObject {
    
    static let shared = SignInWithPhoneHelper()
    
    @Published var verificationID: String?
    @Published var smsCode: String = ""
    private init() { }

    func startSignInWithPhoneFlow(phoneNumber: String) async throws {
        do {
            verificationID = try await AuthenticationManager.shared.startAuth(phoneNumber: phoneNumber)
            print("Verification ID: \(String(describing: verificationID))")
        } catch {
            print("Error starting phone auth: \(error.localizedDescription)")
            throw error
        }
    }

    func verifyCode() async throws -> AuthDataResultModel {
        guard let verificationID = verificationID else {
            throw URLError(.badURL)
        }
        
        do {
            let result = try await AuthenticationManager.shared.verifyCode(verificationID: verificationID, smsCode: smsCode)
            print("Verification successful for user ID: \(result.userId)")
            return result
        } catch {
            print("Error verifying code: \(error.localizedDescription)")
            throw error
        }
    }
}
