//
//  ProfileViewEmployee.swift
//  Peeking
//
//  Created by Will kaminski on 6/10/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileViewEmployee: View {
    @State private var showSettings = false
    @State private var showTips = false
    @State private var showProfileDetail = false
    @State private var showEditProfile = false

    // State variables for storing the user's data
    @State private var userName: String = "Loading..."
    @State private var personalityPhotoURL: String? = nil
    
    var body: some View {
        // Background
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            // Content
            VStack {
                // Top section with settings and tips buttons
                HStack {
                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color.white)
                            .font(.title)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        showTips.toggle()
                    }) {
                        Text("Tips")
                            .foregroundColor(Color.black)
                            .padding(.all, 10.0)
                            .background(Color.white)
                            .cornerRadius(10)
                        
                    }
                    .padding([.top, .trailing])
                }
                .padding(.top, 20)
                
                // Avatar and position selector, should be pfp, can click to change
                VStack(spacing: 20) {
                    Image("tgprofile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100).colorInvert()
                    
                    Text(userName)
                        .font(.title)
                        .onAppear {
                            loadUserData()
                        }
                    
                    Text("What employers see")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .italic()
                }
                .padding(.horizontal)
                
                // User's personality photo
                if let personalityPhotoURL = personalityPhotoURL {
                    AsyncImage(url: URL(string: personalityPhotoURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 350)
                            .cornerRadius(10)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                            .frame(width: 250, height: 350)
                            .cornerRadius(10)
                    }
                    .onTapGesture {
                        showProfileDetail.toggle()
                    }
                } else {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 250, height: 350)
                        .cornerRadius(10)
                        .padding(.horizontal, 50.0)
                        .onTapGesture {
                            showProfileDetail.toggle()
                        }
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 20) {
                    Spacer()
                    
                    Button(action: {
                        // Handle visibility action
                    }) {
                        VStack {
                            Image(systemName: "eye")
                                .font(.title)
                                .foregroundColor(.black)
                            Text("Visible")
                                .font(.footnote)
                                .foregroundColor(Color.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showEditProfile.toggle()
                    }) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.title)
                                .foregroundColor(.black)
                            Text("Edit Profile")
                                .font(.footnote)
                                .foregroundColor(Color.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.bottom, 70).padding(.top, 10).padding(.trailing, 100)
            }
            // Logic to open other views
            if showProfileDetail {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showProfileDetail = false
                    }
                
                ProfileDetailView(showProfileDetail: $showProfileDetail)
                    .padding(.horizontal, 40)
            }
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $showEditProfile) {
            EditProfile()
        }
        .sheet(isPresented: $showTips) {
            TipsView()
        }
    }
    
    // Function to load the user's data from Firestore
    private func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                self.userName = document.data()?["name"] as? String ?? "Name not found"
                self.personalityPhotoURL = document.data()?["personality_photo"] as? String
            } else {
                print("User document does not exist")
            }
        }
    }
}

#Preview {
    ProfileViewEmployee()
}
