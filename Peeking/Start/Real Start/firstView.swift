//
//  firstView.swift
//  Peeking
//
//  Created by Will kaminski on 7/1/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth

struct SignInWithAppleuttonViewRepresentable: UIViewRepresentable {
    
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}

@MainActor
final class AuthenticationViewModel: NSObject, ObservableObject {
    
    private var currentNonce: String?
    
    func signInwithApple(tokens: String) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", IDToken: tokens.idToken, rawNonce: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signInApple() async throws {
        let nonce = randomNonceString()
        let sha = sha256(nonce)
    }
    
    
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
        
}


extension AuthenticationViewModel: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential, including the user's full name.
      let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                        rawNonce: nonce,
                                                        fullName: appleIDCredential.fullName)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if error {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
          print(error.localizedDescription)
          return
        }
        // User is signed in to Firebase with Apple.
        // ...
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}


struct firstView: View {
    @State private var showSignInView: Bool = false
    @State private var isProfileSetupComplete: Bool = false
    var body: some View {
        NavigationStack {
            NavigationLink(destination: PhoneAuthView(showSignInView: $showSignInView, isProfileSetupComplete: $isProfileSetupComplete)) {
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("Employer")
                            .font(.title3)
                            .foregroundColor(Color.white)
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }.background(Color.blue)
            }
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInApple()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                SignInWithAppleuttonViewRepresentable(type: .default, style: .black)
                    .allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
            })
                .frame(height:55)
            
            
        }
    }
}

#Preview {
    firstView()
}
