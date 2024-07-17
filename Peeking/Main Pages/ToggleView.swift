//
//  ToggleView.swift
//  Peeking
//
//  Created by Will kaminski on 6/11/24.
//

import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseAuth

struct ToggleView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var distance: Double = 30
    @State private var showLocationView = false
    
    @State private var selectedField1 = ""
    @State private var selectedField2 = ""
    @State private var selectedField3 = ""
    
    @State private var selectedEmployer1 = ""
    @State private var selectedEmployer2 = ""
    @State private var selectedEmployer3 = ""
    
    @State private var selectedSetting1 = ""
    @State private var selectedSetting2 = ""
    @State private var selectedSetting3 = ""
    
    @State private var selectedStatus1 = ""
    @State private var selectedStatus2 = ""
    @State private var selectedStatus3 = ""
    
    @State private var selectedStart1 = ""
    @State private var selectedStart2 = ""
    @State private var selectedStart3 = ""

    @State private var isLoading = true

    var fieldOptions = ["Consulting", "IT Consulting", "Management Consulting"]
    var employerOptions = ["Startup", "Small Business", "Independent Client", "Corporate"]
    var workSettingOptions = ["Remote", "In-Person", "Hybrid"]
    var employmentStatusOptions = ["Part-time", "Full-Time", "Temporary", "Internship"]
    var StartOptions = ["Fall", "Winter", "Spring", "Summer", "Any"]

    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                Text("Loading...")
            } else {
                VStack {
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
                
                ScrollView {
                    VStack(spacing: 20) {
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
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Field/Niche")
                            HStack {
                                Text("1st Choice").foregroundColor(.gray).padding(.leading)
                                Spacer()
                                Text("2nd Choice").foregroundColor(.gray)
                                Spacer()
                                Text("3rd Choice").foregroundColor(.gray).padding(.trailing)
                            }
                            HStack {
                                DropdownMenuButton(title: $selectedField1, options: fieldOptions)
                                DropdownMenuButton(title: $selectedField2, options: fieldOptions)
                                DropdownMenuButton(title: $selectedField3, options: fieldOptions)
                            }
                        }
                        .padding()
                        
                        Divider().background(Color.gray)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Type of Employer")
                            HStack {
                                Text("1st Choice").foregroundColor(.gray).padding(.leading)
                                Spacer()
                                Text("2nd Choice").foregroundColor(.gray)
                                Spacer()
                                Text("3rd Choice").foregroundColor(.gray).padding(.trailing)
                            }
                            HStack {
                                DropdownMenuButton(title: $selectedEmployer1, options: employerOptions)
                                DropdownMenuButton(title: $selectedEmployer2, options: employerOptions)
                                DropdownMenuButton(title: $selectedEmployer3, options: employerOptions)
                            }
                        }
                        .padding()
                        
                        Divider().background(Color.gray)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Work Setting")
                            HStack {
                                Text("1st Choice").foregroundColor(.gray).padding(.leading)
                                Spacer()
                                Text("2nd Choice").foregroundColor(.gray)
                                Spacer()
                                Text("3rd Choice").foregroundColor(.gray).padding(.trailing)
                            }
                            HStack(spacing: 10) {
                                DropdownMenuButton(title: $selectedSetting1, options: workSettingOptions)
                                DropdownMenuButton(title: $selectedSetting2, options: workSettingOptions)
                                DropdownMenuButton(title: $selectedSetting3, options: workSettingOptions)
                            }
                        }
                        .padding()
                        
                        Divider().background(Color.gray)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Employment Status")
                            HStack {
                                Text("1st Choice").foregroundColor(.gray).padding(.leading)
                                Spacer()
                                Text("2nd Choice").foregroundColor(.gray)
                                Spacer()
                                Text("3rd Choice").foregroundColor(.gray).padding(.trailing)
                            }
                            HStack {
                                DropdownMenuButton(title: $selectedStatus1, options: employmentStatusOptions)
                                DropdownMenuButton(title: $selectedStatus2, options: employmentStatusOptions)
                                DropdownMenuButton(title: $selectedStatus3, options: employmentStatusOptions)
                            }
                        }
                        .padding()
                        
                        Divider().background(Color.gray)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Start Time")
                            HStack {
                                Text("1st Choice").foregroundColor(.gray).padding(.leading)
                                Spacer()
                                Text("2nd Choice").foregroundColor(.gray)
                                Spacer()
                                Text("3rd Choice").foregroundColor(.gray).padding(.trailing)
                            }
                            HStack {
                                Spacer()
                                DropdownMenuButton(title: $selectedStart1, options: StartOptions)
                                Spacer()
                                DropdownMenuButton(title: $selectedStart2, options: StartOptions)
                                Spacer()
                                DropdownMenuButton(title: $selectedStart3, options: StartOptions)
                                Spacer()
                            }
                        }
                        .padding()
                        
                        Divider().background(Color.gray)
                        
                        Button(action: {
                            saveSettings()
                        }) {
                            Text("Save and Exit")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .padding()
        .onAppear {
            loadSettings()
        }
    }

    private func loadSettings() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                self.distance = data["distance"] as? Double ?? 30

                let fields = data["fields"] as? [String] ?? []
                if fields.count >= 3 {
                    self.selectedField1 = fields[0]
                    self.selectedField2 = fields[1]
                    self.selectedField3 = fields[2]
                }

                let employers = data["employer"] as? [String] ?? []
                if employers.count >= 3 {
                    self.selectedEmployer1 = employers[0]
                    self.selectedEmployer2 = employers[1]
                    self.selectedEmployer3 = employers[2]
                }

                let settings = data["workSetting"] as? [String] ?? []
                if settings.count >= 3 {
                    self.selectedSetting1 = settings[0]
                    self.selectedSetting2 = settings[1]
                    self.selectedSetting3 = settings[2]
                }

                let statuses = data["status"] as? [String] ?? []
                if statuses.count >= 3 {
                    self.selectedStatus1 = statuses[0]
                    self.selectedStatus2 = statuses[1]
                    self.selectedStatus3 = statuses[2]
                }

                let starts = data["start"] as? [String] ?? []
                if starts.count >= 3 {
                    self.selectedStart1 = starts[0]
                    self.selectedStart2 = starts[1]
                    self.selectedStart3 = starts[2]
                }
            }
            self.isLoading = false
        }
    }

    private func saveSettings() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let updates: [String: Any] = [
            "distance": distance,
            "fields": [selectedField1, selectedField2, selectedField3],
            "employer": [selectedEmployer1, selectedEmployer2, selectedEmployer3],
            "workSetting": [selectedSetting1, selectedSetting2, selectedSetting3],
            "status": [selectedStatus1, selectedStatus2, selectedStatus3],
            "start": [selectedStart1, selectedStart2, selectedStart3]
        ]

        Firestore.firestore().collection("users").document(userId).updateData(updates) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

//Drop down menu for each button with the custom items above
struct DropdownMenuButton: View {
    @Binding var title: String
    let options: [String]

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    title = option
                }) {
                    Text(option)
                }
            }
        } label: {
            Text(title)
                .foregroundColor(.black)
                .padding()
                .background(Color.orange.opacity(0.7))
                .cornerRadius(10)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}
//New vier when expand location
struct LocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var streetAddress: String = ""
    @State private var city: String = ""
    @State private var selectedState: String = "California"
    @State private var zipCode: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isGeocoding = false
    
    let states = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]

    var body: some View {
        VStack(spacing: 20) {
            // Exit page
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black).font(.system(size: 25))
                }
                Spacer()
            }
            .padding()

            Text("Location Settings")
                .font(.title)
                .fontWeight(.bold)
            
            // Location settings
            VStack(alignment: .leading) {
                Text("Street Address")
                TextField("Enter street address", text: $streetAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)
                
                Text("City")
                TextField("Enter city", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)
                
                Text("State")
                Picker("State", selection: $selectedState) {
                    ForEach(states, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.bottom)
                
                Text("Zip Code")
                TextField("Enter zip code", text: $zipCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            .padding()

            // Save and Exit button
            Button(action: {
                saveLocation()
            }) {
                Text("Save and Exit")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .disabled(isGeocoding)
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func saveLocation() {
        let address = "\(streetAddress), \(city), \(selectedState), \(zipCode)"
        geocode(address: address) { location, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
            } else if let location = location {
                updateLocationInFirestore(location: location)
            }
        }
    }
    
    func geocode(address: String, completion: @escaping (CLLocation?, Error?) -> Void) {
        isGeocoding = true
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            isGeocoding = false
            if let error = error {
                completion(nil, error)
            } else if let placemark = placemarks?.first, let location = placemark.location {
                completion(location, nil)
            } else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location not found"]))
            }
        }
    }
    
    func updateLocationInFirestore(location: CLLocation) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        Task {
            do {
                try await ProfileUpdater.shared.updateLocation(userId: userId, location: geoPoint)
                presentationMode.wrappedValue.dismiss()
            } catch {
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
}

#Preview {
    ToggleView()
}
