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
    @State private var showSignInView: Bool = false
    @State private var isProfileSetupComplete: Bool = false
    @StateObject private var appleSignInManager = AppleSignInManager()
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: PhoneAuthView(showSignInView: $showSignInView, isProfileSetupComplete: $isProfileSetupComplete)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Employer")
                            .font(.title3)
                            .foregroundColor(Color.white)
                    }
                    .padding()
                }
                .background(Color.blue)
            }
            
            
                
                
                SignInWithAppleButton(onRequest: { request in
                    appleSignInManager.handleSignInWithAppleRequest(request)
                }, onCompletion: { result in
                    appleSignInManager.handleSignInWithAppleCompletion(result) { success in
                        if success {
                            // Handle successful sign-in
                            isProfileSetupComplete = false  // Ensure user needs to complete profile setup
                            showSignInView = false
                        } else {
                            // Handle sign-in error
                        }
                    }
                })
                .frame(height: 55)
                .cornerRadius(8)
                .padding()
                
                
        }
    }
}

#Preview {
    firstView()
}
