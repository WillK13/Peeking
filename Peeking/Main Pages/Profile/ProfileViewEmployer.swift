//
//  ProfileViewEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct ProfileViewEmployer: View {
    @State private var selectedPosition = "Position name"
    @State private var positions = ["Position name", "Position 1", "Position 2"]
    @State private var showSettings = false
    @State private var showProfileDetail = false

    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            
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
                        // Handle tips action
                    }) {
                        Text("Tips")
                            .foregroundColor(Color.black)
                            .padding(.all, 10.0)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.trailing)
                }
                .padding(.top, 20)
                
                // Avatar and position selector
                VStack(spacing: 20) {
                    Image("profile60")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    
                    Menu {
                        ForEach(positions, id: \.self) { position in
                            Button(action: {
                                selectedPosition = position
                            }) {
                                Text(position)
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
                        // Handle delete profile action
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
                        // Handle edit profile action
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
    }
}

struct ProfileDetailView: View {
    @Binding var showProfileDetail: Bool

    var body: some View {
        VStack {
            HStack {
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
                    .fontWeight(.bold).padding(.bottom, 300.0).padding(.horizontal, 50)
                
                // Add the content of your profile detail view here
                
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 20)
        }
        }
}

#Preview {
    ProfileViewEmployer()
}
