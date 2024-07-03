//
//  SettingsView.swift
//  Peeking
//
//  Created by Will kaminski on 6/9/24.
//

import SwiftUI

@MainActor
final class SettingViewModel: ObservableObject {
    func signOut() throws {
        try PhoneAuthManager.shared.signOut()
        print("Logged out")
    }
}

struct SettingsView: View {
    // Variables for showing different views
    @Environment(\.presentationMode) var presentationMode
    @State private var showReportProblem = false
    @State private var showSubscriptionSettings = false
    @State private var showDeleteConfirmation = false
    @State private var showLogOutConfirmation = false
    @Binding var showSignInView: Bool

    var body: some View {
        // This is all a pop up
        NavigationView {
            // Background
            ZStack {
                BackgroundView()
                    .edgesIgnoringSafeArea(.all)
                // Content
                VStack {
                    // Back button
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
                    // All of the sections
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
                            showLogOutConfirmation.toggle()
                        }) {
                            Text("Log Out")
                                .foregroundColor(.red)
                                .padding(10.0)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }
                    // Delete account and an are you sure pop up
                    HStack {
                        Button(action: {
                            showDeleteConfirmation.toggle()
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
                // Logic for opening pop ups
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
                
                if showDeleteConfirmation {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showDeleteConfirmation = false
                        }
                    
                    DeleteConfirmationView(showDeleteConfirmation: $showDeleteConfirmation)
                        .padding(.horizontal, 40)
                }
                
                if showLogOutConfirmation {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showLogOutConfirmation = false
                        }
                    LogOutConfirmationView(showLogOutConfirmation: $showLogOutConfirmation, showSignInView: $showSignInView)
                        .padding(.horizontal, 40)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
// View for pop ups
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
// View for report
struct ReportProblemView: View {
    // Variables for drop down
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
// View for subscription
struct SubscriptionSettingsView: View {
    // Vars for plan, needs to be dynamic based on what you have
    @Binding var showSubscriptionSettings: Bool
    @State private var selectedPlan = "Glider"

    var body: some View {
        
        VStack(spacing: 20) {
            Text("Subscription Settings")
                .font(.title)
                
            // This info needs to change as well.
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
            // Needs to be greyed out if action is not possible, also then cant click.
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
// The are you sure you want to delete
struct DeleteConfirmationView: View {
    @Binding var showDeleteConfirmation: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to delete your account?")
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
                // Have to connect to account then and delete
                Button(action: {
                    // Handle delete action
                    showDeleteConfirmation = false
                    // Add delete logic here
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

// The are you sure you want to delete
struct LogOutConfirmationView: View {
    @Binding var showLogOutConfirmation: Bool
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to log out?")
                .font(.title2)
            // The buttons yes or no
            HStack {
                Button(action: {
                    showLogOutConfirmation = false
                }) {
                    Text("No")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(10)
                }
                
                
                    // Have to connect to account then and delete
                    Button(action: {
                        // Handle delete action
                        showLogOutConfirmation = false
                        // Add delete logic here
                        Task {
                            do { try viewModel.signOut()
                                showSignInView = true
                            } catch {
                                print(error)
                            }
                        }
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
// Deal with pop ups
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
    SettingsView(showSignInView: .constant(false))
}
