//
//  SettingsView.swift
//  Peeking
//
//  Created by Will kaminski on 6/9/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showReportProblem = false
    @State private var showSubscriptionSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
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

                    VStack(spacing: 20) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                            .padding(.vertical, 30.0)
                            .font(.system(size: 70))
                        
                        Button(action: {
                            // Handle push notifications action
                        }) {
                            SettingsButton(title: "Push Notifications")
                        }
                        
                        Button(action: {
                            showReportProblem.toggle()
                        }) {
                            SettingsButton(title: "Report a Problem")
                        }
                        
                        Link(destination: URL(string: "https://www.example.com/how-does-it-work")!) {
                            SettingsButton(title: "How Does it Work?")
                        }
                        
                        Link(destination: URL(string: "https://www.example.com/terms-of-use")!) {
                            SettingsButton(title: "Terms of Use")
                        }
                        
                        Button(action: {
                            // Handle account details action
                        }) {
                            SettingsButton(title: "Account Details")
                        }
                        
                        Button(action: {
                            showSubscriptionSettings.toggle()
                        }) {
                            SettingsButton(title: "Subscription Settings")
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, -100)

                    Spacer()
                    HStack {
                        Button(action: {
                            // Handle delete account action
                        }) {
                            Text("Delete Account")
                                .foregroundColor(.red)
                                .padding(5.0)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 30).padding(.leading, 20)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Image("Duck_Body").resizable().aspectRatio(contentMode: .fill).padding(.trailing, 140.0).frame(width: 10.0, height: 70.0)
                    }
                    
                    Spacer()
                }
                
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

struct SettingsButton: View {
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

struct ReportProblemView: View {
    @Binding var showReportProblem: Bool
    @State private var selectedSubject = "Select a subject"
    @State private var details = ""
    
    let subjects = ["Bug", "Feedback", "Other"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Report a Problem")
                .font(.title)
                .fontWeight(.bold)
            
            Menu {
                ForEach(subjects, id: \.self) { subject in
                    Button(action: {
                        selectedSubject = subject
                    }) {
                        Text(subject)
                    }
                }
            } label: {
                HStack {
                    Text(selectedSubject)
                        .foregroundColor(.black)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
            
            TextEditor(text: $details)
                .padding()
                .frame(height: 150)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .placeholder(when: details.isEmpty) {
                    Text("Type details here...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
            
            Button(action: {
                // Handle submit action
                showReportProblem = false
            }) {
                Text("Submit")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("TopOrange"))
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}

struct SubscriptionSettingsView: View {
    @Binding var showSubscriptionSettings: Bool
    @State private var selectedPlan = "Glider"

    var body: some View {
        
        VStack(spacing: 20) {
            Text("Subscription Settings")
                .font(.title)
                
            
            HStack {
                Text(selectedPlan)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text("6 Month - $39.95")
                        .font(.headline)
                    Text("Renews December 11")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
            
            HStack {
                Button(action: {
                    // Handle restore action
                }) {
                    Text("Restore")
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Handle cancel subscription action
                }) {
                    Text("Cancel Active Subscription")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
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

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    SettingsView()
}
