//
//  ProfileViewEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileViewEmployer: View {
    // Variables for positions and pop-up views
    @State private var selectedPosition = "Position name"
    @State private var positions: [Position] = [Position(title: "Position name", id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString)]
    @State private var showSettings = false
    @State private var showTips = false
    @State private var showProfileDetail = false
    @State private var showDeleteConfirmation = false
    @State private var showEditProfile = false
    @State private var showFirstView = false

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
                
                // Avatar and position selector
                VStack(spacing: 20) {
                    Image("profile60")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100).colorInvert()
                    
                    CustomMenu {
                        ForEach(positions, id: \.id) { position in
                            if position.title == "Locked position" {
                                Text(position.title)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                Button(action: {
                                    selectedPosition = position.title
                                }) {
                                    Text(position.title)
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedPosition)
                                .foregroundColor(Color.black)
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    }
                    .onAppear {
                        loadPositions()
                    }
                    
                    Text("What job-seekers see")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .italic()
                }
                .padding(.horizontal)
                
                // Placeholder for content
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 250.0, height: 350)
                    .cornerRadius(10)
                    .padding(.horizontal, 50.0)
                    .onTapGesture {
                        showProfileDetail.toggle()
                    }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 20) {
                    Button(action: {
                        showDeleteConfirmation.toggle()
                    }) {
                        VStack {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                            Text("Delete Profile")
                                .font(.footnote)
                                .foregroundColor(Color.black)
                        }
                        .padding(5.0)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.top, 20)
                    }
                    
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
                .padding(.bottom, 70).padding(.top, 10)
            }
            // Logic for opening pop-ups
            if showProfileDetail {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showProfileDetail = false
                    }
                
                ProfileDetailView(showProfileDetail: $showProfileDetail)
                    .padding(.horizontal, 40)
            }
            
            if showDeleteConfirmation {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showDeleteConfirmation = false
                    }
                DeleteConfirmationViewProfile(showDeleteConfirmation: $showDeleteConfirmation, showFirstView: $showFirstView)
                    .padding(.horizontal, 40)
            }
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $showEditProfile) {
            EditProfileEmployer()
        }
        .sheet(isPresented: $showTips) {
            TipsView()
        }
        .fullScreenCover(isPresented: $showFirstView) {
            newposition()
        }
    }
    
    // Function to load the employer's positions from Firestore
    private func loadPositions() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).collection("profile").document("profile_data").getDocument { document, error in
            if let document = document, document.exists {
                if let title = document.data()?["title"] as? String, !title.isEmpty {
                    self.positions = [Position(title: title, id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString)]
                    self.selectedPosition = title
                } else {
                    self.positions = [Position(title: "Position name", id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString)]
                }
            } else {
                print("Profile document does not exist")
            }
        }
    }
}

// Position struct to ensure unique IDs for each position
struct Position: Identifiable {
    var title: String
    var id: String
}

// Custom menu to handle disabled options
struct CustomMenu<Content: View, Label: View>: View {
    let content: Content
    let label: Label

    init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.content = content()
        self.label = label()
    }

    var body: some View {
        Menu {
            content
        } label: {
            label
        }
    }
}

// The pop-up to show the full profile, can be like main view, be its own file maybe
struct ProfileDetailView: View {
    @Binding var showProfileDetail: Bool

    var body: some View {
        VStack {
            HStack {
                // Close pop-up
                Button(action: {
                    showProfileDetail = false
                }) {
                    Text("X")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                        .cornerRadius(10)
                }
                Spacer()
            }
            
            VStack(spacing: 20) {
                Text("Profile Detail")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 300.0)
                    .padding(.horizontal, 50)
                
                // Add the content of profile
                
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 20)
        }
    }
}

// The pop-up to confirm deletion
struct DeleteConfirmationViewProfile: View {
    @Binding var showDeleteConfirmation: Bool
    @Binding var showFirstView: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to delete your profile?")
                .font(.title2)
            // The buttons yes or no
            HStack {
                Button(action: {
                    showDeleteConfirmation = false
                }) {
                    Text("No")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(10)
                }
                // Handle delete action and navigate to new position view
                Button(action: {
                    showDeleteConfirmation = false
                    showFirstView = true
                }) {
                    Text("Yes")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.red.opacity(0.5))
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}

#Preview {
    ProfileViewEmployer()
}
