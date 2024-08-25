//  EditProfile.swift
//  Peeking
//
//  Created by Will kaminski on 6/21/24.
//

import SwiftUI

struct EditProfile: View {
    //Variables for showing different views
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        //This is all a pop up
        NavigationView {
            //Background
            ZStack {
                BackgroundView()
                    .edgesIgnoringSafeArea(.all)
                //Content
                VStack {
                    //Back button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white).font(.system(size: 25))
                        }
                        .padding(.leading)

                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    //All of the sections
                    VStack(spacing: 20) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.white)
                            .padding(.vertical, 30.0)
                            .font(.system(size: 70))
                        Text("Edit Profile")
                            .font(.largeTitle)
                            .padding(.top, -30.0)
                        Text("Choose a category to edit").italic()
                        
                        NavigationLink(destination: ProfileSetupViewEmployee(fromEditProfile: true)) {
                                SettingsButton1(title: "Basics")
                        }
                        
                        NavigationLink(destination: TechnicalsEmployee( fromEditProfile: true)) {
                                SettingsButton1(title: "Technicals")
                        }
                        
                        NavigationLink(destination: SoftSkills( fromEditProfile: true)) {
                                SettingsButton1(title: "Soft-Skills")
                        }
                        
                        NavigationLink(destination: Hobbies( fromEditProfile: true)) {
                                SettingsButton1(title: "Hobbies and Photo")
                        }
                        
                        NavigationLink(destination: WorkEnviornment( fromEditProfile: true)) {
                                SettingsButton1(title: "Desired Enviornment")
                        }
                        
                    }
                    .padding(.horizontal, 20).padding(.top, -100)

                    Spacer()
                    
                    HStack {
                        Spacer()
                        Image("Duck_Body").resizable().aspectRatio(contentMode: .fill).padding(.trailing, 140.0).frame(width: 10.0, height: 70.0)
                    }
                    
                    Spacer()
                }
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// View for pop ups
struct SettingsButton1: View {
    let title: String

    var body: some View {
            Text(title)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
    }
}

#Preview {
    EditProfile()
}
