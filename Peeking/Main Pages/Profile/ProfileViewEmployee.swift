//
//  ProfileViewEmployee.swift
//  Peeking
//
//  Created by Will kaminski on 6/10/24.
//

import SwiftUI

struct ProfileViewEmployee: View {
    //Vars to toggle views
    @State private var showSettings = false
    @State private var showProfileDetail = false

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
                        //Handle tips action
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
                
                //Avatar and position selector, should be pfp, can click to change
                VStack(spacing: 20) {
                    Image("profile60")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100).colorInvert()
                    
                    Text("Name")
                        .font(.title)
                    
                    Text("What employers see")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .italic()
                }
                .padding(.horizontal)
                
                //Placeholder for content, needs to be dynamic to user data
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
                    Spacer()
                    
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
                        //Handle edit profile action
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
            //Logic to open other views
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

#Preview {
    ProfileViewEmployee()
}
