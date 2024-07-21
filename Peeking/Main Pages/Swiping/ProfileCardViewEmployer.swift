//
//  ProfileCardViewEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 7/20/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileCardViewEmployer: View {
    @Binding var currentStep: Int
    @State private var user: DBUser? = nil
    @State private var profile: Profile? = nil
    @State private var showMission: Bool = false

    var body: some View {
        ZStack {
            // Background view for testing
            BackgroundView()

            Rectangle()
                .fill(Color.white)
                .frame(width: 395, height: 545)
                .cornerRadius(10)
                .padding(.top, -20)

            VStack {
                if let user = user, let profile = profile {
                    VStack(alignment: .leading) {
                        switch currentStep {
                        case 0:
                            EmployerProfileView(user: user, profile: profile, showMission: $showMission)
                        default:
                            Text("Invalid step")
                        }
                    }
                } else {
                    Spacer()
                    Text("Loading employer data...")
                    Spacer()
                }

                HStack {
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(index == currentStep ? Color("SelectColor") : Color("NotSelectedColor"))
                            .frame(width: 65, height: 15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        Spacer()
                    }
                }
                .padding(.top, 20)
            }
            .frame(width: 350, height: 500)
            
            VStack {
                HStack {
                    Spacer()
                    ProfileActionButtons()
                }
                .padding(.trailing, 20)
                .padding(.bottom, 50)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { location in
            let halfScreenWidth = UIScreen.main.bounds.width / 2
            if location.x > halfScreenWidth {
                if currentStep < 4 {
                    currentStep += 1
                }
            } else {
                if currentStep > 0 {
                    currentStep -= 1
                }
            }
        }
        .onAppear {
            loadEmployerData()
        }
        .overlay(
            ZStack {
                if showMission {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showMission = false
                        }

                    VStack {
                        Text(user?.mission ?? "No mission available")
                            .font(.headline)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding()
                }
            }
        )
    }

    private func loadEmployerData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let docRef = Firestore.firestore().collection("users").document(userId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: DBUser.self)
                    self.user = user
                    loadProfileData(userId: userId)
                } catch {
                    print("Error decoding employer data: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func loadProfileData(userId: String) {
        let profileRef = Firestore.firestore().collection("users").document(userId).collection("profile").document("profile_data")
        profileRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let profile = try document.data(as: Profile.self)
                    self.profile = profile
                } catch {
                    print("Error decoding profile data: \(error)")
                }
            } else {
                print("Profile document does not exist")
            }
        }
    }
}

struct EmployerProfileView: View {
    let user: DBUser
    let profile: Profile
    @Binding var showMission: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(user.name ?? "Name not available")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.leading)
                    .onTapGesture {
                        showMission = true
                    }
                Spacer()
            }
            .padding(.top, 10)
            
            Divider()
                .background(Color.black)
                .padding(.leading)
                .padding(.trailing, 150)
                .padding(.top, -10)

            HStack {
                Text(profile.title)
                    .font(.headline)
                    .fontWeight(.regular)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 18)
                    .background(Color.white)
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black, lineWidth: 1)
                    )
                Spacer()
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 10)
            .padding(.top, -5)
            
            HStack {
                Text(profile.description)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 18)
                Spacer()
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 10)
            .padding(.top, -5)

            // Employment Type and other tags
            VStack(alignment: .leading) {
                HStack {
                    ForEach(profile.employment_type, id: \.self) { type in
                        Text(type)
                            .font(.footnote)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 28)
                            .background(Color.yellow)
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
                .padding([.leading, .trailing])
                .padding(.bottom, 10)
                .padding(.top, -5)

                HStack {
                    ForEach(profile.setting, id: \.self) { setting in
                        Text(setting)
                            .font(.footnote)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 28)
                            .background(Color.yellow)
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
                .padding([.leading, .trailing])
                .padding(.bottom, 10)
                .padding(.top, -5)

                HStack {
                    ForEach(profile.time, id: \.self) { time in
                        Text(time)
                            .font(.footnote)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 28)
                            .background(Color.yellow)
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
                .padding([.leading, .trailing])
                .padding(.bottom, 10)
                .padding(.top, -5)
            }

            // Fields
            HStack {
                ForEach(profile.fields, id: \.self) { field in
                    Text(field)
                        .font(.footnote)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 28)
                        .background(Color.white)
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 10)
            .padding(.top, -5)

            Text("Workplace Languages")
                .font(.headline)
                .fontWeight(.regular)
                .padding(.leading)
                .padding(.bottom, 5)

            HStack {
                ForEach(user.languages ?? [], id: \.self) { language in
                    Text(language)
                        .font(.footnote)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 28)
                        .background(Color.white)
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 10)
            .padding(.top, -5)

            Spacer()
        }
    }
}

struct ProfileCardViewEmployer_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCardViewEmployer(currentStep: .constant(0))
    }
}
