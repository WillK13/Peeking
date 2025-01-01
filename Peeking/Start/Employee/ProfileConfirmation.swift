//
//  ProfileConfirmation.swift
//  Peeking
//
//  Created by Will kaminski on 6/20/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileConfirmation: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var currentStep = 0
    @State private var navigateToMainView = false
    @State private var showLoadingIndicator = false
    @State private var userId: String = Auth.auth().currentUser?.uid ?? ""
    @State private var buttons = false

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
                    
                    ProfileCardView(currentStep: $currentStep, userId: $userId, needsButtons: $buttons)
                    if (buttons == false) {
                        HStack {
                            Spacer()
                            ForEach(0..<5) { index in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(index == currentStep ? Color("SelectColor") : Color("NotSelectedColor"))
                                    .frame(width: 65, height: 15)
                                    .onTapGesture {
                                        currentStep = index
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
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
                                            APIClient.shared.performAnalysis(userId: userId, userType: 0) { result in
                                                switch result {
                                                case .success:
                                                    APIClient.shared.simpleMatch(userId: userId, userType: 0) { matchResult in
                                                        showLoadingIndicator = false
                                                        switch matchResult {
                                                        case .success:
                                                            navigateToMainView = true
                                                        case .failure(let error):
                                                            print("Failed to perform match: \(error.localizedDescription)")
                                                        }
                                                    }
                                                case .failure(let error):
                                                    showLoadingIndicator = false
                                                    print("Failed to perform analysis: \(error.localizedDescription)")
                                                }
                                            }
                                        }
                                    } catch {
                                        print("Failed to update profile.")
                                        showLoadingIndicator = false
                                    }
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

struct ProfileConfirmation_Previews: PreviewProvider {
    static var previews: some View {
        ProfileConfirmation()
            .environmentObject(AppViewModel())
    }
}
