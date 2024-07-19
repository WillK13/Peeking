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
    @State private var currentStep = 0
    @State private var navigateToMainView = false
    @State private var showLoadingIndicator = false
    //@StateObject private var userManager = UserManager()

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
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 395, height: 545)
                            .cornerRadius(10)
                            .padding(.top, -20)

                        VStack(alignment: .trailing) {
                            Button(action: {
                                // Bookmark action
                            }) {
                                Image(systemName: "bookmark")
                                    .resizable()
                                    .frame(width: 40, height: 50)
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                // Heart action
                            }) {
                                Image(systemName: "heart")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding([.bottom, .trailing], 10)
                                    .foregroundColor(.black)
                            }
                            
                            Button(action: {
                                // Ellipsis action
                            }) {
                                Image(systemName: "ellipsis")
                                    .resizable()
                                    .frame(width: 40, height: 9)
                                    .padding([.bottom, .trailing], 10)
                                    .foregroundColor(.black)
                            }
                            
                            HStack {
                                ForEach(0..<5) { index in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(index == currentStep ? Color("SelectColor") : Color("NotSelectedColor"))
                                        .frame(width: 65, height: 15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black, lineWidth: 2)
                                        )
                                    Spacer()
                                }
                            }
                        }
                        .frame(width: 350, height: 500)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        let halfScreenWidth = UIScreen.main.bounds.width / 2
                        if location.x > halfScreenWidth {
                            if currentStep < 4 {
                                currentStep += 1
                            }
                        } else {
                            if currentStep > 0 {
                                currentStep -= 1
                            }
                        }
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
            }
        }
    }
}

struct ProfileConfirmationEmployer_Previews: PreviewProvider {
    static var previews: some View {
        ProfileConfirmationEmployer()
    }
}
