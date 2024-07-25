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
    @State private var photoURL: String? = nil
    @State private var logoURL: String? = nil
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 395, height: 545)
                .cornerRadius(10)

            if let photoURL = photoURL {
                AsyncImage(url: URL(string: photoURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()  // Ensures the image fills the space
                        .frame(width: 395, height: 545)  // Matches the white box dimensions
                        .clipped()  // Clips any overflowing parts
                        .cornerRadius(10)
                        .opacity(currentStep == 4 ? 1.0 : 0.2)
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .cornerRadius(10)
                }
            }

            VStack {
                if let user = user, let profile = profile {
                    VStack(alignment: .leading) {
                        switch currentStep {
                        case 0:
                            EmployerProfileView(user: user, profile: profile, showMission: $showMission, logoURL: logoURL)
                        case 1:
                            EmployerTechnicalCertificationsView(profile: profile)
                        case 2:
                            EmployerWorkEnvironmentView(user: user)
                        case 3:
                            EmployerSupportManagementView(user: user)
                        default:
                            HobbiesViewEmployer(user: user)
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
                    Color.gray.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showMission = false
                        }
                        .padding(.bottom, 10)
                        .padding(.top, -10)

                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Mission").font(.subheadline).underline()
                                    .padding([.top, .leading, .trailing], 20)
                                    .padding(.bottom, 5)
                                Text(user?.mission ?? "No mission available")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .padding([.leading, .bottom, .trailing], 20)
                                    .italic()
                            }
                            .background(Color.white)
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding(.leading)
                            .padding(.top, 55)
                            Spacer()
                        }
                        Spacer()
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
                    fetchPhoto(userId: userId)
                    fetchLogo(userId: userId)
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

    private func fetchPhoto(userId: String) {
        StorageManager.shared.getProfileImageURL(userId: userId, folder: "photo") { result in
            switch result {
            case .success(let url):
                self.photoURL = url
            case .failure(let error):
                print("Failed to fetch photo URL: \(error)")
            }
        }
    }

    private func fetchLogo(userId: String) {
        StorageManager.shared.getProfileImageURL(userId: userId, folder: "logo") { result in
            switch result {
            case .success(let url):
                self.logoURL = url
            case .failure(let error):
                print("Failed to fetch logo URL: \(error)")
            }
        }
    }
}

struct EmployerProfileView: View {
    let user: DBUser
    let profile: Profile
    @Binding var showMission: Bool
    let logoURL: String?

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

                if let logoURL = logoURL {
                    AsyncImage(url: URL(string: logoURL)) { image in
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                    }
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
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 18)
                Spacer()
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 10)
            .padding(.top, -5)

            // Employment Type and other tags
            VStack(alignment: .leading) {
                HStack {
                    ForEach(profile.employment_type + (user.type ?? []), id: \.self) { type in
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
            .padding(.bottom)
            .padding(.top)
            Spacer()
            Text("Workplace Languages")
                .font(.headline)
                .fontWeight(.regular)
                .padding(.leading)

            Divider()
                .background(Color.black)
                .padding(.leading)
                .padding(.trailing, 150)
                .padding(.bottom, 5)
                .padding(.top, -5)

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

            Spacer()
        }
    }
}

struct EmployerWorkEnvironmentView: View {
    let user: DBUser

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack{
                    Text("General Work Environment")
                        .font(.headline)
                        .fontWeight(.regular)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 18)
                        .background(Color("WE-SS"))
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding([.leading, .trailing, .top])
                    Spacer()
                }
                HStack {
                    if let generalWorkEnvironment = user.workEnvio?[0].split(separator: ",").map(String.init) {
                        VStack(alignment: .leading) {
                            ForEach(generalWorkEnvironment, id: \.self) { item in
                                HStack {
                                    Text("• \(item)")
                                        .padding(.leading)
                                    Spacer()
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding([.leading, .trailing])
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                    } else {
                        Text("No general work environment listed")
                            .padding([.leading, .trailing])
                            .padding(.bottom, 20)
                            .padding(.top, 10)
                    }
                    Spacer()
                }
                Spacer()
            }

            VStack(alignment: .leading) {
                HStack {
                    Text("Team Dynamics")
                        .font(.headline)
                        .fontWeight(.regular)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 18)
                        .background(Color("WE-SS"))
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding([.leading, .trailing, .top])
                    Spacer()
                }
                HStack {
                    if let teamDynamics = user.workEnvio?[1].split(separator: ",").map(String.init) {
                        VStack(alignment: .leading) {
                            ForEach(teamDynamics, id: \.self) { item in
                                HStack {
                                    Text("• \(item)")
                                        .padding(.leading)
                                    Spacer()
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding([.leading, .trailing])
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                    } else {
                        Text("No team dynamics listed")
                            .padding([.leading, .trailing])
                            .padding(.bottom, 20)
                            .padding(.top, 10)
                    }
                    Spacer()
                }
                Spacer()
            }

            VStack(alignment: .leading) {
                HStack {
                    Text("Work Hour Flexibility")
                        .font(.headline)
                        .fontWeight(.regular)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 18)
                        .background(Color("WE-SS"))
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding([.leading, .trailing, .top])
                    Spacer()
                }
                HStack {
                    if let workHourFlexibility = user.workEnvio?[2].split(separator: ",").map(String.init) {
                        VStack(alignment: .leading) {
                            ForEach(workHourFlexibility, id: \.self) { item in
                                HStack {
                                    Text("• \(item)")
                                        .padding(.leading)
                                    Spacer()
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding([.leading, .trailing])
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                    } else {
                        Text("No work hour flexibility listed")
                            .padding([.leading, .trailing])
                            .padding(.bottom, 20)
                            .padding(.top, 10)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .padding([.leading, .trailing], 5.0)
    }
}

struct EmployerTechnicalCertificationsView: View {
    let profile: Profile

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Desired Technicals")
                    .font(.headline)
                    .fontWeight(.regular)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 18)
                    .background(Color("Techs"))
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding([.leading, .trailing, .top])
                
                if let technicals = profile.technicals.first?.split(separator: ",").map(String.init) {
                    VStack(alignment: .leading) {
                        ForEach(technicals, id: \.self) { technical in
                            HStack {
                                Text("• \(technical)")
                                    .padding(.leading)
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding([.leading, .trailing])
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                } else {
                    Text("No desired technicals listed")
                        .padding([.leading, .trailing])
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                }
                Spacer()
            }

            VStack(alignment: .leading) {
                Text("Desired Certifications")
                    .font(.headline)
                    .fontWeight(.regular)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 18)
                    .background(Color("Techs"))
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding([.leading, .trailing, .top])
                
                if let certifications = profile.technicals.dropFirst().first?.split(separator: ",").map(String.init) {
                    VStack(alignment: .leading) {
                        ForEach(certifications, id: \.self) { certification in
                            HStack {
                                Text("• \(certification)")
                                    .padding(.leading)
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding([.leading, .trailing])
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                } else {
                    Text("No desired certifications listed")
                        .padding([.leading, .trailing])
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                }
                Spacer()
            }
        }
        .padding([.leading, .trailing], 5.0)
    }
}

struct EmployerSupportManagementView: View {
    let user: DBUser

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Employee Support")
                        .font(.headline)
                        .fontWeight(.regular)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 18)
                        .background(Color("WE-SS"))
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding([.leading, .trailing, .top])
                    Spacer()
                }
                HStack {
                    if let employeeSupport = user.workEnvio?[3].split(separator: ",").map(String.init) {
                        VStack(alignment: .leading) {
                            ForEach(employeeSupport, id: \.self) { item in
                                HStack {
                                    Text("• \(item)")
                                        .padding(.leading)
                                    Spacer()
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding([.leading, .trailing])
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                    } else {
                        Text("No employee support listed")
                            .padding([.leading, .trailing])
                            .padding(.bottom, 20)
                            .padding(.top, 10)
                    }
                    Spacer()
                }
                Spacer()
            }

            VStack(alignment: .leading) {
                HStack {
                    Text("Management Approach")
                        .font(.headline)
                        .fontWeight(.regular)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 18)
                        .background(Color("WE-SS"))
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding([.leading, .trailing, .top])
                    Spacer()
                }
                HStack {
                    if let managementApproach = user.workEnvio?[4].split(separator: ",").map(String.init) {
                        VStack(alignment: .leading) {
                            ForEach(managementApproach, id: \.self) { item in
                                HStack {
                                    Text("• \(item)")
                                        .padding(.leading)
                                    Spacer()
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding([.leading, .trailing])
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                    } else {
                        Text("No management approach listed")
                            .padding([.leading, .trailing])
                            .padding(.bottom, 20)
                            .padding(.top, 10)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .padding([.leading, .trailing], 5.0)
    }
}

struct HobbiesViewEmployer: View {
    let user: DBUser

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Employee Hobbies")
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
                    .padding([.leading, .trailing, .top])
                Spacer()
            }
            .padding(.trailing)
            
            HStack {
                Text(user.hobbies ?? "No hobbies listed")
                    .font(.subheadline)
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
            .padding(.top, 10)
            
            Spacer()
        }
        .padding([.leading, .trailing], 5.0)
    }
}

struct ProfileCardViewEmployer_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCardViewEmployer(currentStep: .constant(0))
    }
}
