//
//  SettingsView.swift
//  Peeking
//
//  Created by Will kaminski on 6/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class SettingViewModel: ObservableObject {
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
        print("Logged out")
    }
}

@MainActor
final class SettingViewModel2: ObservableObject {
    func deleteUser() async throws {
        try await AuthenticationManager.shared.delete()
        print("Account Deleted")
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showReportProblem = false
    @State private var showSubscriptionSettings = false
    @State private var showDeleteConfirmation = false
    @State private var showLogOutConfirmation = false
    @State private var showFirstView = false
    @State private var showReauthenticationView = false
    @State private var showDeleteProfileConfirmation = false
    @State private var userType: Int?

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
                            openAppSettings()
                        }) {
                            SettingsButton(im: "pushnoti", title: "Push Notifications")
                        }

                        Button(action: {
                            showReportProblem.toggle()
                        }) {
                            SettingsButton(im: "report", title: "Report a Problem")
                        }
                        
                        Link(destination: URL(string: "https://peeking.ai/privacy-policy")!) {
                            SettingsButton(im: "rocket", title: "Tips for Success")
                        }

                        Link(destination: URL(string: "https://peeking.ai/privacy-policy")!) {
                            SettingsButton(im: "privacy", title: "Privacy Policy")
                        }

                        Link(destination: URL(string: "https://peeking.ai/terms-and-conditions")!) {
                            SettingsButton(im: "terms", title: "Terms of Use")
                        }

                        Button(action: {
                            showSubscriptionSettings.toggle()
                        }) {
                            SettingsButton(im: "tiers", title: "Subscription Settings")
                        }

                        Link(destination: URL(string: "https://peeking.ai/contact")!) {
                            SettingsButton(im: "profilesetting", title: "Contact a Founder")
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, -100)

                    Spacer()

                    HStack {
                        VStack {
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
                            
                            if userType == 1 {
                                HStack {
                                    Button(action: {
                                        showDeleteProfileConfirmation.toggle()
                                    }) {
                                        Text("Delete Profile")
                                            .foregroundColor(.red)
                                            .padding(5.0)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                    }
                                    .padding(.bottom, 30).padding(.leading, 20)
                                    Spacer()
                                }
                            }
                                
                            HStack {
                                Button(action: {
                                    showReauthenticationView.toggle()
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
                            
                        }
                        Spacer()
                        Image("Duck_Body").resizable().aspectRatio(contentMode: .fill).padding(.trailing, 140.0).frame(width: 10.0, height: 50.0)
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

                if showLogOutConfirmation {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showLogOutConfirmation = false
                        }
                    LogOutConfirmationView(showLogOutConfirmation: $showLogOutConfirmation, showFirstView: $showFirstView)
                        .padding(.horizontal, 40)
                }

                if showReauthenticationView {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showReauthenticationView = false
                        }
                    ReauthenticationView(showReauthenticationView: $showReauthenticationView, showFirstView: $showFirstView)
                        .padding(.horizontal, 40)
                }
                if showDeleteProfileConfirmation {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showDeleteProfileConfirmation = false
                        }
                    DeleteConfirmationViewProfile(showDeleteConfirmation: $showDeleteProfileConfirmation, showFirstView: $showFirstView)
                        .padding(.horizontal, 40)
                }
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $showFirstView) {
            firstView()
        }
        .onAppear {
                    fetchUserType()
        }
    }
    private func fetchUserType() {
            guard let currentUserId = Auth.auth().currentUser?.uid else { return }
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(currentUserId)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.userType = document.data()?["user_type"] as? Int
                } else {
                    print("Document does not exist")
                }
            }
        }
    func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }

}

// View for pop ups
struct SettingsButton: View {
    var im: String
    let title: String

    var body: some View {
        HStack {
            Image(im)
                .padding(.leading, 10)
        Spacer()
            Text(title)
                .foregroundColor(.black)
                .padding()
            Spacer()
        }
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
                .scrollContentBackground(.hidden)

            
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.black, lineWidth: 1)
//                )
                .placeholder(when: details.isEmpty) {
                    Text("Type details here...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
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
//                Text(selectedPlan)
//                    .foregroundColor(.black)
//                    .padding()
//                    .background(Color.blue.opacity(0.2))
//                    .cornerRadius(10)
//
//                VStack(alignment: .leading) {
//                    Text("6 Month - $39.95")
//                        .font(.headline)
//                    Text("Renews December 11")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//                Spacer()
                Text("No Subscriptions available")
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
            // Needs to be greyed out if action is not possible, also then cant click.
//            HStack {
//                Button(action: {
//                    // Handle restore action
//                }) {
//                    Text("Restore")
//                        .foregroundColor(.gray)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(10)
//                }

//                Button(action: {
//                    // Handle cancel subscription action
//                }) {
//                    Text("Cancel Active Subscription")
//                        .font(.caption)
//                        .foregroundColor(.red)
//                        .padding()
//                        .background(Color.white)
////                        .cornerRadius(10)
//                }
//            }
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
    @StateObject private var viewModel2 = SettingViewModel2()
    @Binding var showFirstView: Bool

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
                    showFirstView = false
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
    @StateObject private var viewModel2 = SettingViewModel()
    @Binding var showFirstView: Bool

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
                    Task {
                        do {
                            try viewModel2.signOut()
                            //viewModel.loadCurrentUser()
                            showFirstView = true
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
    SettingsView()
}
