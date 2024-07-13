//
//  searchsettings.swift
//  Peeking
//
//  Created by Will kaminski on 6/21/24.
//

import SwiftUI

struct searchsettings: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var distance: Double = 30
    @State private var exp: Double = 5
    @State private var showLocationView = false

    // State variables for selected options
    @State private var acceptedFields: [String] = []
    @State private var acceptedEducation: [String] = []
    @State private var showFieldOptions = false
    @State private var showEducationOptions = false
    @State private var fieldSearchText = ""
    @State private var educationSearchText = ""

    // Options for all of the drop downs.
    var fieldOptions = ["Consulting", "IT Consulting", "Management Consulting", "Medical Track", "Healthcare", "Startup", "Small Business", "Independent Client", "Corporate"]
    var educationOptions = ["Currently enrolled in High School", "Highschool Graduate", "GED", "Currently enrolled in Master's Degree Program", "Currently enrolled in Associate's Degree Program", "Currently enrolled in Bachelor's Degree Program", "Currently enrolled in Doctorate Program", "Doctorate", "Associate's Degree", "Bachelor's Degree", "Master's Degree"]

    var body: some View {
        VStack(spacing: 20) {
            VStack {
                // Back arrow
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black).font(.system(size: 25))
                    }
                    Spacer()
                }
                .padding([.top, .leading, .trailing])
                
                Text("Search Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom)
            }.background(Color.gray.opacity(0.2)).cornerRadius(10)
            // The main view area
            ScrollView {
                VStack(spacing: 20) {
                    // Location
                    HStack {
                        Text("Location")
                        Spacer()
                        Button(action: {
                            showLocationView.toggle()
                        }) {
                            HStack {
                                Text("Position Location\nBoston, MA")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.trailing)
                                Image(systemName: "chevron.right")
                            }
                        }
                        .fullScreenCover(isPresented: $showLocationView) {
                            LocationView()
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(Color.gray)
                    // Distance toggle
                    VStack(spacing: 10) {
                        HStack {
                            Text("Distance")
                            Spacer()
                        }
                        Slider(value: $distance, in: 0...100)
                        Text("Up to \(Int(distance)) miles")
                    }
                    .padding(.horizontal)
                    
                    Divider().background(Color.gray)
                    // Experience toggle
                    VStack(spacing: 10) {
                        HStack {
                            Text("Years of Experience")
                            Spacer()
                        }
                        Slider(value: $exp, in: 0...20)
                        Text("At least \(Int(exp)) years")
                    }
                    .padding(.horizontal)
                    
                    Divider().background(Color.gray)
                    // Accepted Fields of Experience
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Accepted Fields of Experience")
                        HStack {
                            TextField("Search or add", text: $fieldSearchText, onEditingChanged: { _ in
                                showFieldOptions = true
                            })
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(15)
                            .overlay(
                                HStack {
                                    Spacer()
                                    Image(systemName: "magnifyingglass")
                                        .padding(.trailing, 10)
                                }
                            )
                        }
                        .padding(.horizontal)
                        
                        if showFieldOptions {
                            VStack {
                                ForEach(fieldOptions.filter { $0.lowercased().contains(fieldSearchText.lowercased()) }, id: \.self) { option in
                                    HStack {
                                        Text(option)
                                            .foregroundColor(Color.black)
                                            .padding(10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                        Button(action: {
                                            if (!acceptedFields.contains(option)) {
                                                acceptedFields.append(option)
                                            }
                                            fieldSearchText = ""
                                            showFieldOptions = false
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.green)
                                                .padding(.trailing, 10)
                                                .font(.system(size: 25))
                                        }
                                    }
                                    .onTapGesture {
                                        if (!acceptedFields.contains(option)) {
                                            acceptedFields.append(option)
                                        }
                                        fieldSearchText = ""
                                        showFieldOptions = false
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        FlowLayout(alignment: .leading) {
                            ForEach(acceptedFields, id: \.self) { field in
                                HStack {
                                    Text(field)
                                        .padding(10)
                                        .background(Color("TopOrange"))
                                        .cornerRadius(5)
                                    Button(action: {
                                        acceptedFields.removeAll { $0 == field }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    Divider().background(Color.gray)
                    // Accepted Levels of Education
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Accepted Levels of Education")
                        HStack {
                            TextField("Search or add", text: $educationSearchText, onEditingChanged: { _ in
                                showEducationOptions = true
                            })
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(15)
                            .overlay(
                                HStack {
                                    Spacer()
                                    Image(systemName: "magnifyingglass")
                                        .padding(.trailing, 10)
                                }
                            )
                        }
                        .padding(.horizontal)
                        
                        if showEducationOptions {
                            VStack {
                                ForEach(educationOptions.filter { $0.lowercased().contains(educationSearchText.lowercased()) }, id: \.self) { option in
                                    HStack {
                                        Text(option)
                                            .foregroundColor(Color.black)
                                            .padding(10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                        Button(action: {
                                            if (!acceptedEducation.contains(option)) {
                                                acceptedEducation.append(option)
                                            }
                                            educationSearchText = ""
                                            showEducationOptions = false
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.green)
                                                .padding(.trailing, 10)
                                                .font(.system(size: 25))
                                        }
                                    }
                                    .onTapGesture {
                                        if (!acceptedEducation.contains(option)) {
                                            acceptedEducation.append(option)
                                        }
                                        educationSearchText = ""
                                        showEducationOptions = false
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        FlowLayout(alignment: .leading) {
                            ForEach(acceptedEducation, id: \.self) { education in
                                HStack {
                                    Text(education)
                                        .padding(10)
                                        .background(Color("TopOrange"))
                                        .cornerRadius(5)
                                    Button(action: {
                                        acceptedEducation.removeAll { $0 == education }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    Divider().background(Color.gray)
                    // Save and Exit button
                    NavigationView {
                        HStack {
                            Spacer()
                            // Next Button
                            let fromEditProfile: Bool = false
                            NavigationLink(destination: DesiredTechnicals(fromEditProfile: fromEditProfile).navigationBarBackButtonHidden(true)) {
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
                }
                .padding(.bottom, 20) // Add some bottom padding to ensure the last item is fully visible
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    func isFormComplete() -> Bool {
        return !acceptedFields.isEmpty && !acceptedEducation.isEmpty
    }
}

#Preview {
    searchsettings()
}
