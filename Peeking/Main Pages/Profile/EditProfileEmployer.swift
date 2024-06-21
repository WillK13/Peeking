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
    @State private var showReportProblem = false
    @State private var showSubscriptionSettings = false
    @State private var showDeleteConfirmation = false

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
                        Button(action: {
                            //Handle push notifications action
                        }) {
                            SettingsButton(title: "Basics")
                        }
                        
                        Button(action: {
                            showReportProblem.toggle()
                        }) {
                            SettingsButton(title: "Desired Technicals")
                        }
                        
                        Button(action: {
                            //Handle account details action
                        }) {
                            SettingsButton(title: "Work Enviornment")
                        }
                        
                        Button(action: {
                            //Handle account details action
                        }) {
                            SettingsButton(title: "Hobbies and Photo")
                        }
                        
                        Button(action: {
                            //Handle account details action
                        }) {
                            SettingsButton(title: "Desired Soft-Skills")
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
                //Logic for opening pop ups
                if showReportProblem {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showReportProblem = false
                        }
                    
                    ReportProblemView(showReportProblem: $showReportProblem)
                        .padding(.horizontal, 40)
                }
                
                if showSubscriptionSettings {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showSubscriptionSettings = false
                        }
                    
                    SubscriptionSettingsView(showSubscriptionSettings: $showSubscriptionSettings)
                        .padding(.horizontal, 40)
                }
                
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    EditProfileEmployer()
}
