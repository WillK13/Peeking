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
                if let user = user {
                    VStack(alignment: .leading) {
                        switch currentStep {
                        case 0:
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
                                                .cornerRadius(5)
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
                                                .cornerRadius(5)
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
                        case 1:
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Technical Skills")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 18)
                                        .background(Color.green.opacity(0.3))
                                        .cornerRadius(50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .stroke(Color.black, lineWidth: 1)
                                        )
                                        .padding([.leading, .trailing, .top])
                                    
                                    Spacer()
                                }
                                
                                Text(user.technicals?[0] ?? "No technical skills listed")
                                    .padding([.leading, .trailing])
                                    .padding(.bottom, 20)
                                    .padding(.top, 10)
                                
                                Text("Certifications")
                                    .font(.headline)
                                    .fontWeight(.regular)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 18)
                                    .background(Color.green.opacity(0.3))
                                    .cornerRadius(50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                    .padding([.leading, .trailing])
                                
                                Text(user.technicals?[1] ?? "No certifications listed")
                                    .padding([.leading, .trailing])
                                    .padding(.bottom, 20)
                                    .padding(.top, 10)
                                
                                Spacer()
                            }
                            .padding([.leading, .trailing], 5.0)
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
}

struct ProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCardView(currentStep: .constant(0))
    }
}
