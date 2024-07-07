//
//  firstView.swift
//  Peeking
//
//  Created by Will kaminski on 7/1/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct firstView: View {
    @StateObject private var appleSignInManager = SignInAppleHelper()
    @StateObject private var authViewModel = AuthenticationViewModel()
    @State private var showPhoneAuthView = false
    @State private var showWelcomeView = false
    @State private var showContentView = false
    
    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Welcome to Peeking")
                    .font(.title)
                    .padding(.bottom, 10.0)
                Text("Choose your sign-in method")
                    .padding(.bottom, 20.0)
                
                Button(action: {
                        showPhoneAuthView = true
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Phone Number")
                                .font(.title3)
                                .foregroundColor(Color.black)
                        }
                        .padding()
                        .frame(width: 250.0, height: 75)
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                }
                
                SignInWithAppleButtonViewRepresentable(type: .signIn, style: .black)
                    .onTapGesture {
                        Task {
                            do {
                                try await authViewModel.signInApple()
                                // After sign-in, check if the user profile is created
                                if let user = try? AuthenticationManager.shared.getAuthenticatedUser(),
                                   let dbUser = try? await UserManager.shared.getUser(userId: user.userId) {
                                    if dbUser.isProfileSetupComplete == true {
                                        showContentView = true
                                    } else {
                                        showWelcomeView = true
                                    }
                                }
                            } catch {
                                // Handle sign-in error
                                print("Error signing in with Apple: \(error)")
                            }
                        }
                    }
                    .frame(width: 250.0, height: 75)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .fullScreenCover(isPresented: $showPhoneAuthView) {
            PhoneAuthView(authViewModel: authViewModel)
        }
        .fullScreenCover(isPresented: $showWelcomeView) {
            Welcome()
        }
        .fullScreenCover(isPresented: $showContentView) {
            ContentView()
        }
    }
}

#Preview {
    firstView()
}
