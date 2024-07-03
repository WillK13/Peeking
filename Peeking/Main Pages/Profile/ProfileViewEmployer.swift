//
//  ProfileViewEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct ProfileViewEmployer: View {
    //Variables for positions and open all pop ups
    @State private var selectedPosition = "Position name"
    @State private var positions = ["Position name", "Position 1", "Position 2"]
    @State private var showSettings = false
    @State private var showTips = false
    @State private var showProfileDetail = false
    @State private var showDeleteConfirmation = false
    @State private var showEditProfile = false
    @State private var showSignInView = false



    var body: some View {
        //Background
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            //Content
            VStack {
                //Top section with settings and tips buttons
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
                
                //Avatar and position selector, should change to user pfp?
                VStack(spacing: 20) {
                    Image("profile60")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100).colorInvert()
                    
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
                
                //Placeholder for content, should show their profile, maybe make this a seperate view?
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 250.0, height: 350)
                    .cornerRadius(10)
                    .padding(.horizontal, 50.0)
                    .onTapGesture {
                        showProfileDetail.toggle()
                    }
                
                Spacer()
                
                //Action buttons
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
                        //Handle visibility action
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
            //Logic for openning pop ups
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
                
                DeleteConfirmationView(showDeleteConfirmation: $showDeleteConfirmation)
                    .padding(.horizontal, 40)
            }
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView(showSignInView: $showSignInView)
        }
        .fullScreenCover(isPresented: $showEditProfile) {
            EditProfileEmployer(isProfileSetupComplete: .constant(false), normalOpen: .constant(true))
        }
        .sheet(isPresented: $showTips) {
            TipsView()
        }
    }
}
//The pop up to full profile, can be like main view, be its own file maybe
struct ProfileDetailView: View {
    @Binding var showProfileDetail: Bool

    var body: some View {
        VStack {
            HStack {
                //Close pop up
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
                
                //Add the content of profile
                
                
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
