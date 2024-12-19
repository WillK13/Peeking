//
//  hobbiesemployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/21/24.
//

import SwiftUI
import FirebaseAuth

struct hobbiesemployer: View {
    @Environment(\.presentationMode) var presentationMode
    var fromEditProfile: Bool // Flag to indicate if opened from EditProfile

    @State private var hobbies: String = ""
    @State private var inputImage: UIImage? = nil
    @State private var profileImage: Image? = nil
    @State private var showingImagePicker = false
    @State private var isSaving: Bool = false
    @State private var navigateToNextView: Bool = false
    @State private var hobbiestext: String = ""

    let characterLimit = 50

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack() {
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                        }
                        // Custom back arrow
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            Spacer()
                            if fromEditProfile {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 30.0)
                                    .font(.system(size: 70))
                                Spacer()
                                
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Done")
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color(.white))
                                        .cornerRadius(5)
                                }
                            }
                        }
                        .padding(.leading)
                        
                        HStack {
                            Spacer()
                            Text("Hobbies and Photo")
                                .font(.largeTitle)
                                .padding(.top)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("These will be publicly visible")
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                            Spacer()
                        }
                        // Hobbies
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading) {
                                CustomTextField3(title: "List any notable hobbies or fun facts.", text: $hobbiestext, characterLimit: characterLimit)
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // Photo
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Upload a photo of your workplace.")
                                .font(.headline)
                                .fontWeight(.regular)
                                .padding()
                                .padding(.leading, -10)
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("Or something that represents your workplace.")
                                .foregroundColor(.gray)
                                .italic()
                                .padding(.horizontal).padding(.top, -10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack {
                                HStack {
                                    if let profileImage = profileImage {
                                        profileImage
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 150)
                                            .clipShape(Rectangle())
                                            .cornerRadius(10)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 200.0, height: 150)
                                            .cornerRadius(10)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .foregroundColor(.gray)
                                            )
                                    }
                                    Image("uploadimage")
                                }
                            }
                            .onTapGesture {
                                self.showingImagePicker = true
                            }
                            .padding(.bottom, 10)
                        }
                        
                        Spacer()
                        if !fromEditProfile {
                            HStack {
                                Spacer()
                                // Next Button
                                NavigationLink(destination: ProfileConfirmationEmployer(), isActive: $navigateToNextView) {
                                    Button(action: {
                                        Task {
                                            await saveHobbiesAndPhoto()
                                        }
                                    }) {
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(isFormComplete() ? Color.black : Color.gray)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(25)
                                            .shadow(radius: 10)
                                    }
                                    .disabled(!isFormComplete() || isSaving)
                                    .padding(.top, 30)
                                    .padding(.bottom, 50)
                                }.disabled(!isFormComplete() || isSaving)
                            }
                        }
                    }
                    .padding()
                    .navigationBarBackButtonHidden(true)
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func isFormComplete() -> Bool {
        return !hobbiestext.isEmpty && profileImage != nil
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }

    func saveHobbiesAndPhoto() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let inputImage = inputImage else { return }

        isSaving = true

        StorageManager.shared.uploadProfileImage(userId: userId, image: inputImage, folder: "photo") { result in
            switch result {
            case .success(let photoURL):
                Task {
                    do {
                        try await ProfileUpdaterEmployer.shared.updateHobbiesAndPhoto(
                            userId: userId,
                            hobbies: hobbiestext,
                            photoURL: photoURL
                        )

                        // Perform analysis after updating hobbies
                        APIClient.shared.performAnalysis(userId: userId, userType: 1) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    navigateToNextView = true
                                }
                            case .failure(let error):
                                print("Error performing analysis: \(error.localizedDescription)")
                                DispatchQueue.main.async {
                                    isSaving = false
                                }
                            }
                        }
                    } catch {
                        // Handle error
                        print("Error updating hobbies: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            isSaving = false
                        }
                    }
                }
            case .failure(let error):
                // Handle error
                print("Failed to upload image: \(error)")
                DispatchQueue.main.async {
                    isSaving = false
                }
            }
        }
    }


}

#Preview {
    hobbiesemployer(fromEditProfile: false)
}
