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
    let urlTerms = URL(string: "https://www.google.com")!
    let urlPrivacyPolicy = URL(string: "https://www.stackoverflow.com")!
    
    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text("Peeking")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 10.0)
                Image("Duck_Body")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                    .padding(.bottom, 35)
                Text("Simplified Mobile")
                    .font(.title2)
                    .foregroundColor(Color.white)
                   
                Text(" Job-Matching")
                    .font(.title2)
                    .foregroundColor(Color.white)
                Spacer()
                VStack(alignment: .center) {
                    
                    
                    Button(action: { UIApplication.shared.open(self.urlTerms) }) {
                        Text("By signing in by “Phone Number” or “Apple ID”, you agree to our ")
                        + Text("Terms")
                            .foregroundColor(Color.blue)
                            .underline()
                        + Text(".")
                    }
                    .foregroundColor(Color.black)
                    .font(.subheadline)
                    .italic()
                    
                    
                    
                    Button(action: { UIApplication.shared.open(self.urlPrivacyPolicy) }) {
                        Text("Find out how we handle your data in our  ")
                        + Text("Privacy Policy")
                            .foregroundColor(Color.blue)
                            .underline()
                        + Text(".")
                    }
                    .foregroundColor(Color.black)
                    .font(.subheadline)
                    .italic()
 
                    
                }.multilineTextAlignment(.center)
                    .padding(.horizontal, 30.0)
                
                Text("Log In / Sign Up")
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                Button(action: {
                        showPhoneAuthView = true
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Phone Number")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.black)
                        }
                        .frame(width: 320.0, height: 50)
                    }
                    .background(Color.white)
                    .cornerRadius(50)
                }
                
                SignInWithAppleButtonViewRepresentable(type: .signIn, style: .white)
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
                    .frame(width: 320.0, height: 55)
                    .cornerRadius(50)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                
                Text("Support?")
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: "https://google.com")!)
                    }
                    .fontWeight(.semibold)
                    .opacity(0.8)
                    
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
