//
//  Hobbies.swift
//  Peeking
//
//  Created by Will kaminski on 6/20/24.
//

import SwiftUI
import FirebaseAuth

struct Hobbies: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var hobbies: String = ""
    @State private var inputImage: UIImage? = nil
    @State private var profileImage: Image? = nil
    @State private var showingImagePicker = false
    @State private var navigateToNextView: Bool = false
    @State private var isSaving: Bool = false // Add a state for the saving process
    var fromEditProfile: Bool // Flag to indicate if opened from EditProfile

    let characterLimit = 50

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading) {
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
                                Text("List any notable hobbies.")
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                                    .fixedSize(horizontal: false, vertical: true)
                                Text("(ie: DJ-ing, origami, gardening)")
                                    .foregroundColor(.gray)
                                    .italic()
                                    .padding([.horizontal])
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            ZStack(alignment: .leading) {
                                if hobbies.isEmpty {
                                    Text("Type here...")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 5)
                                }
                                TextEditor(text: $hobbies)
                                    .onChange(of: hobbies) { oldValue, newValue in
                                        if newValue.count > characterLimit {
                                            hobbies = String(newValue.prefix(characterLimit))
                                        }
                                    }
                                    .padding(.horizontal, 5)
                                    .frame(height: 100)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                            }
                            Text("\(hobbies.count)/\(characterLimit) characters")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.bottom, 20)
                        
                        // Photo
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Upload a photo that represents you.")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("NOT A PHOTO OF YOU")
                                .foregroundColor(.black)
                                .italic()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Spacer()
                                ZStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 200.0, height: 150)
                                        .cornerRadius(10)
                                    
                                    if let profileImage = profileImage {
                                        profileImage
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 150)
                                            .clipShape(Rectangle())
                                            .cornerRadius(10)
                                    } else {
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                    }
                                }.padding(.trailing, 150)
                                Spacer()
                            }
                            .onTapGesture {
                                self.showingImagePicker = true
                            }
                            .padding(.bottom, 10)
                            
                            Text("Example: Sunset, beach, gym, video games, vikings, etc.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                        if !fromEditProfile {
                        HStack {
                            Spacer()
                            // Next Button
                            NavigationLink(destination: ProfileConfirmation(), isActive: $navigateToNextView) {
                                Button(action: {
                                    Task {
                                        await saveHobbiesAndPhoto()
                                    }
                                }) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(25)
                                        .shadow(radius: 10)
                                        .opacity(isFormComplete() ? 1.0 : 0.5)
                                }
                                .disabled(!isFormComplete() || isSaving)
                                .padding(.top, 30)
                                .padding(.bottom, 50)
                            }
                        }
                    }
                    }
                    .padding()
                    
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }

            }

        }                    .navigationBarBackButtonHidden(true)

    }

    
    func isFormComplete() -> Bool {
        return !hobbies.isEmpty && profileImage != nil
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }

    func saveHobbiesAndPhoto() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        guard let inputImage = inputImage else { return }

        isSaving = true

        StorageManager.shared.uploadProfileImage(userId: userId, image: inputImage, folder: "personality") { result in
            switch result {
            case .success(let photoURL):
                Task {
                    do {
                        try await ProfileUpdater.shared.updateHobbies(userId: userId, hobbies: hobbies, photoURL: photoURL)
                        navigateToNextView = true
                    } catch {
                        // Handle error
                    }
                    isSaving = false
                }
            case .failure(let error):
                // Handle error
                print("Failed to upload image: \(error)")
                isSaving = false
            }
        }
    }

}

struct Hobbies_Previews: PreviewProvider {
    static var previews: some View {
        Hobbies(fromEditProfile: false)
    }
}
