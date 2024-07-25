//
//  ProfileCardView.swift
//  Peeking
//
//  Created by Will kaminski on 7/18/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileCardView: View {
    @Binding var currentStep: Int
    @State private var user: DBUser? = nil
    @State private var experiences: [Experience] = []
    @State private var personalityPhotoURL: String? = nil

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 395, height: 545)
                .cornerRadius(10)
                
            if let personalityPhotoURL = personalityPhotoURL {
                AsyncImage(url: URL(string: personalityPhotoURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()  // Ensures the image fills the space
                        .frame(width: 395, height: 545)  // Matches the white box dimensions
                        .clipped()  // Clips any overflowing parts
                        .cornerRadius(10)
                        .opacity(currentStep == 4 ? 1.0 : 0.2)
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .frame(width: 395, height: 545)
                        .cornerRadius(10)
                }
            }

            VStack {
                if let user = user {
                    VStack(alignment: .leading) {
                        switch currentStep {
                        case 0:
                            UserProfileView(user: user, experiences: experiences)
                        case 1:
                            TechnicalSkillsView(user: user)
                        case 2:
                            SoftSkillsView(user: user)
                        case 3:
                            HandleChallengesView(user: user)
                        case 4:
                            HobbiesView(user: user)
                        default:
                            Text("Invalid step")
                        }
                    }
                } else {
                    Spacer()
                    Text("Loading user data...")
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
            loadUserData()
        }
    }

    private func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let docRef = Firestore.firestore().collection("users").document(userId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: DBUser.self)
                    self.user = user
                    loadExperiences(userId: userId)
                    fetchPersonalityPhoto(userId: userId)
                } catch {
                    print("Error decoding user data: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    private func loadExperiences(userId: String) {
        let experiencesRef = Firestore.firestore().collection("users").document(userId).collection("experience")
        experiencesRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting experiences: \(error)")
            } else {
                if let snapshot = snapshot {
                    self.experiences = snapshot.documents.compactMap { doc in
                        try? doc.data(as: Experience.self)
                    }
                }
            }
        }
    }

    private func fetchPersonalityPhoto(userId: String) {
        StorageManager.shared.getProfileImageURL(userId: userId, folder: "personality") { result in
            switch result {
            case .success(let url):
                self.personalityPhotoURL = url
            case .failure(let error):
                print("Failed to fetch personality photo URL: \(error)")
            }
        }
    }
}

struct UserProfileView: View {
    let user: DBUser
    let experiences: [Experience]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(user.name ?? "Name not available")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.leading)
                Text("\(user.age ?? 0)")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.trailing)
                Spacer()
            }
            .padding(.top, 10)
            
            Divider()
                .background(Color.black)
                .padding(.leading)
                .padding(.trailing, 150)
                .padding(.top, -10)
            
            HStack {
                ForEach(user.languages ?? [], id: \.self) { language in
                    Text(language)
                        .font(.footnote)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 28)
                        .background(Color("TopOrange"))
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

            VStack(alignment: .leading, spacing: 10) {
                ForEach(experiences) { experience in
                    HStack {
                        Text("\(experience.field) - \(experience.years) yrs")
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
                    .padding([.leading, .trailing, .bottom], 5)
                }
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 10)
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(user.education ?? [], id: \.self) { education in
                    HStack {
                        Text(education)
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
                    .padding([.leading, .trailing, .bottom], 5)
                }
            }
            .padding([.leading, .trailing])
            .padding(.top, 20)
            Spacer()
        }
    }
}

struct TechnicalSkillsView: View {
    let user: DBUser

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Technical Skills")
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
                
                Spacer()
            }
            
            if let technicalSkills = user.technicals?[0].split(separator: ",").map(String.init) {
                VStack(alignment: .leading) {
                    ForEach(technicalSkills, id: \.self) { skill in
                        HStack {
                            Text("• \(skill)")
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
                Text("No technical skills listed")
                    .padding([.leading, .trailing])
                    .padding(.bottom, 20)
                    .padding(.top, 10)
            }
            
            Text("Certifications")
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
                .padding([.leading, .trailing])
            
            if let certifications = user.technicals?[1].split(separator: ",").map(String.init) {
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
                Text("No certifications listed")
                    .padding([.leading, .trailing])
                    .padding(.bottom, 20)
                    .padding(.top, 10)
            }
            
            Spacer()
        }
        .padding([.leading, .trailing], 5.0)
    }
}

struct SoftSkillsView: View {
    let user: DBUser

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Top Qualities")
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
            
            if let topQualities = user.soft_skills?[0].split(separator: ",").map(String.init) {
                VStack(alignment: .leading) {
                    ForEach(topQualities, id: \.self) { quality in
                        HStack {
                            Text("• \(quality)")
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
                Text("No top qualities listed")
                    .padding([.leading, .trailing])
                    .padding(.bottom, 20)
                    .padding(.top, 10)
            }
            
            Text("Strongest Soft-Skills")
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
                .padding([.leading, .trailing])
            
            if let softSkills = user.soft_skills?[1].split(separator: ",").map(String.init) {
                VStack(alignment: .leading) {
                    ForEach(softSkills, id: \.self) { skill in
                        HStack {
                            Text("• \(skill)")
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
                Text("No strongest soft-skills listed")
                    .padding([.leading, .trailing])
                    .padding(.bottom, 20)
                    .padding(.top, 10)
            }
            
            Text("Skills for Teamwork")
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
                .padding([.leading, .trailing])
            
            if let teamworkSkills = user.soft_skills?[2].split(separator: ",").map(String.init) {
                VStack(alignment: .leading) {
                    ForEach(teamworkSkills, id: \.self) { skill in
                        HStack {
                            Text("• \(skill)")
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
                Text("No skills for teamwork listed")
                    .padding([.leading, .trailing])
                    .padding(.bottom, 20)
                    .padding(.top, 10)
            }
            
            Spacer()
        }
        .padding([.leading, .trailing], 5.0)
    }
}

struct HandleChallengesView: View {
    let user: DBUser

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("How \(user.name ?? "the user") Handles Challenges and Conflicts")
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
            .padding(.trailing, 15.0)
            
            if let challenges = user.soft_skills?[3].split(separator: ",").map(String.init) {
                VStack(alignment: .leading) {
                    ForEach(challenges, id: \.self) { challenge in
                        HStack {
                            Text("• \(challenge)")
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
                Text("No data available")
                    .padding([.leading, .trailing])
                    .padding(.bottom, 20)
                    .padding(.top, 10)
            }
            
            HStack {
                Text("How \(user.name ?? "the user") Builds Relationships")
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
            
            if let relationships = user.soft_skills?[4].split(separator: ",").map(String.init) {
                VStack(alignment: .leading) {
                    ForEach(relationships, id: \.self) { relationship in
                        HStack {
                            Text("• \(relationship)")
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
                Text("No data available")
                    .padding([.leading, .trailing])
                    .padding(.bottom, 20)
                    .padding(.top, 10)
            }
            
            Spacer()
        }
        .padding([.leading, .trailing], 5.0)
    }
}

struct HobbiesView: View {
    let user: DBUser

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Hobbies")
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

struct ProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCardView(currentStep: .constant(0))
    }
}
