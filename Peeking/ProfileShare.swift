//
//  ProfileShare.swift
//  Peeking
//
//  Created by Will kaminski on 8/22/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileShare: View {
    @Binding var userId: String
    @Binding var needsButtons: Bool
    @State private var shareId: String = "..."
    @State private var userType: Int? = nil
    @State private var currentStep: Int = 0
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var goBack = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    Text("X")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .font(.title)
                        .onTapGesture {
                            goBack.toggle()
                        }
                    Spacer()
                    Image("Duck_Head")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .shadow(radius: 2)
                    Spacer()
                    VStack {
                        Text(shareId)
                            .foregroundColor(Color.white)
                        Text("Copy Link")
                            .fontWeight(.light)
                            .foregroundColor(Color.white)
                    }
                    Image("copy")
                        .onTapGesture {
                            UIPasteboard.general.string = shareId
                        }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                if let userType = userType {
                    if userType == 0 {
                        ProfileCardView(currentStep: $currentStep, userId: $userId, needsButtons: $needsButtons)
                            .frame(width: 350, height: 500)
                    } else if userType == 1 {
                        ProfileCardViewEmployer(currentStep: $currentStep, userId: $userId, needsButtons: $needsButtons)
                            .frame(width: 350, height: 500)
                    }
                } else {
                    Text("Loading profile...")
                        .foregroundColor(.white)
                }
                
                if !needsButtons {
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
                
                Spacer()
                
                Text("#GetPeeking")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 20.0)
            }
        }
        .onAppear {
            fetchShareIdAndUserType()
        }
        .fullScreenCover(isPresented: $goBack) {
            ContentView()
                .environmentObject(appViewModel)
        }
    }
    
    private func fetchShareIdAndUserType() {
        let db = Firestore.firestore()
        let userDocument = db.collection("users").document(userId)
        
        userDocument.getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.userType = data["user_type"] as? Int
                
                if let userType = self.userType {
                    if userType == 0 {
                        // Employee, get share_id from base document
                        self.shareId = data["share_id"] as? String ?? "Not Available"
                    } else if userType == 1 {
                        // Employer, get share_id from profile subcollection
                        let profileDocument = userDocument.collection("profile").document("profile_data")
                        profileDocument.getDocument { profileSnapshot, profileError in
                            if let profileData = profileSnapshot?.data() {
                                self.shareId = profileData["share_id"] as? String ?? "Not Available"
                            } else {
                                self.shareId = "Not Available"
                            }
                        }
                    }
                } else {
                    self.shareId = "..."
                }
            } else {
                self.shareId = "..."
            }
        }
    }
}

#Preview {
    ProfileShare(userId: .constant("example_user_id"), needsButtons: .constant(false))
        .environmentObject(AppViewModel()) // Ensure the appViewModel is available for preview
}
