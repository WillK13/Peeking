//
//  firstView.swift
//  Peeking
//
//  Created by Will kaminski on 7/1/24.
//

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
    @StateObject private var appleSignInManager = AppleSignInManager()
    @State private var showPhoneAuthView = false
    @ObservedObject var viewModel: ProfileViewModel
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
                SignInWithAppleButton(onRequest: { request in
                    appleSignInManager.handleSignInWithAppleRequest(request)
                }, onCompletion: { result in
                    appleSignInManager.handleSignInWithAppleCompletion(result) { success in
                        if success {
                            // Handle successful sign-in
                            viewModel.loadCurrentUser()
                            if viewModel.isProfileCreated {
                                showContentView = true
                            } else {
                                showWelcomeView = true
                            }
                        } else {
                            // Handle sign-in error
                        }
                    }
                })
                .frame(width: 250.0, height: 75)
                .cornerRadius(8)
                .padding()
                .colorInvert()
            }
        }.fullScreenCover(isPresented: $showPhoneAuthView) {
            PhoneAuthView(viewModel: viewModel)
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
    firstView(viewModel: ProfileViewModel())
}
