//
//  EditProfileEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/21/24.
//

import SwiftUI

struct EditProfileEmployer: View {
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
                        
                        NavigationLink(destination: ProfileSetupViewEmployer( fromEditProfile: true)) {
                                SettingsButton1(title: "Basics")
                        }
                        
                        NavigationLink(destination: DesiredTechnicals( fromEditProfile: true)) {
                                SettingsButton1(title: "Desired Technicals")
                        }
                        
                        NavigationLink(destination: enviornmentemployer( fromEditProfile: true)) {
                                SettingsButton1(title: "Work Environment")
                        }
                        
                        NavigationLink(destination: hobbiesemployer( fromEditProfile: true)) {
                                SettingsButton1(title: "Hobbies and Photo")
                        }
                        
                        NavigationLink(destination: softskillsemployer( fromEditProfile: true)) {
                                SettingsButton1(title: "Desired Soft-Skills")
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

#Preview {
    EditProfileEmployer()
}
