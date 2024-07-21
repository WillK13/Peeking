//
//  ProfileConfirmationEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 7/18/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileConfirmationEmployer: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var currentStep = 0
    @State private var navigateToMainView = false
    @State private var showLoadingIndicator = false

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    // Custom back arrow
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                                .padding()
                        }
                        Spacer()
                    }
                    .padding(.leading)
                    
                    HStack {
                        Spacer()
                        Text("Profile Confirmation")
                            .font(.largeTitle)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("Visible to Employers")
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    ProfileCardViewEmployer(currentStep: $currentStep)

                    Text("Tap through to continue")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    if currentStep == 4 {
                        HStack {
                            Spacer()
                            Button(action: {
                                Task {
                                    showLoadingIndicator = true
                                    do {
                                        if let userId = Auth.auth().currentUser?.uid {
                                            try await UserManager.shared.updateProfileSetupComplete(userId: userId, isComplete: true)
                                            navigateToMainView = true
                                        }
                                    } catch {
                                        print("Failed to update profile.")
                                    }
                                    showLoadingIndicator = false
                                }
                            }) {
                                Text("Make my profile")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.top, 10)
                                    .padding(.trailing, 40)
                            }
                        }
                    }
                }
                .padding()
                
                if showLoadingIndicator {
                    ProgressView("Updating Profile...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToMainView) {
                ContentView()
                    .environmentObject(appViewModel)
            }
        }
    }
}

struct ProfileConfirmationEmployer_Previews: PreviewProvider {
    static var previews: some View {
        ProfileConfirmationEmployer()
    }
}
