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
    @State private var hobbiestext: String = ""
    var fromEditProfile: Bool // Flag to indicate if opened from EditProfile

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
                            Text("Upload a photo that represents you.")
                                .font(.headline)
                                .fontWeight(.regular)
                                .padding()
                                .padding(.leading, -10)
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("NOT A PHOTO OF YOU")
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
                                }.disabled(!isFormComplete() || isSaving)
                            }
                        }
                    }
                    .padding()
                    
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }

            }

        }
        .navigationBarBackButtonHidden(true)

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

        StorageManager.shared.uploadProfileImage(userId: userId, image: inputImage, folder: "personality") { result in
            switch result {
            case .success(let photoURL):
                Task {
                    do {
                        try await ProfileUpdater.shared.updateHobbies(userId: userId, hobbies: hobbiestext, photoURL: photoURL)
                        
                        // Perform analysis after updating hobbies
                        APIClient.shared.performAnalysis(userId: userId, userType: 0) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    print("Navigation to next view")
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

struct CustomTextField3: View {
    var title: String
    @Binding var text: String
    var characterLimit: Int
    
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text(title)
                    
                
                VStack(alignment: .leading) {
                    Text("(ie: Dj-ing, origami, gardening, professional tennis player, etc)")
                        .font(.body).padding(.leading,-20)
                }
                .foregroundColor(.gray)
                .padding(.trailing, 30)
                .italic()
            }.padding().padding(.trailing, 50)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                .fixedSize(horizontal: false, vertical: true)
            
            ZStack(alignment: .leading) {
                if text.isEmpty && !isEditing {
                    Text("Type here...")
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                }
                TextEditor(text: $text)
                    .onChange(of: text) { oldValue, newValue in
                        if newValue.count > characterLimit {
                            text = String(newValue.prefix(characterLimit))
                        }
                    }
                    .onTapGesture {
                        isEditing = true
                    }
                    .frame(height: 100)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
            }
            
            Text("\(text.count)/\(characterLimit) characters")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct Hobbies_Previews: PreviewProvider {
    static var previews: some View {
        Hobbies(fromEditProfile: false)
    }
}
