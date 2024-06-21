//
//  hobbiesemployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/21/24.
//

import SwiftUI

struct hobbiesemployer: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var hobbies: String = ""
    @State private var inputImage: UIImage? = nil
    @State private var profileImage: Image? = nil
    @State private var showingImagePicker = false

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
                                Text("What are some hobbies of your employees?")
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                                    .fixedSize(horizontal: false, vertical: true)
                                Text("Ex: Camping, family time, team dinners")
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
                            Text("Upload a photo of your workplace.")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("If Applicable")
                                .foregroundColor(.gray)
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
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            // Next Button
                            NavigationLink(destination: ProfileConfirmation()) {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .shadow(radius: 10)
                                    .opacity(isFormComplete() ? 1.0 : 0.5)
                            }
                            .disabled(!isFormComplete())
                            .padding(.top, 30)
                            .padding(.bottom, 50)
                        }
                    }
                    .padding()
                    .navigationBarBackButtonHidden(true)
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }
            }
        }
    }
    func isFormComplete() -> Bool {
        return !hobbies.isEmpty && profileImage != nil
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }
}

#Preview {
    hobbiesemployer()
}
