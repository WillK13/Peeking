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

    @State private var locationText: String = "Loading..."

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

    var fieldOptions = [
        "Architecture",
        "Arts and Entertainment",
        "Automotive",
        "Beauty and Cosmetics",
        "Construction",
        "Consulting",
        "Creative and Design",
        "Cybersecurity",
        "E-commerce",
        "Education",
        "Energy and Utilities",
        "Engineering",
        "Environmental and Agriculture",
        "Event Planning and Management",
        "Fashion",
        "Finance",
        "Food and Beverage",
        "Government and Public Administration",
        "Health and Wellness",
        "Healthcare",
        "Home Improvement",
        "Hospitality and Tourism",
        "Human Resources",
        "IT Services and Consulting",
        "Legal",
        "Manufacturing and Production",
        "Media and Communications",
        "Non-Profit and Social Services",
        "Operations and Logistics",
        "Pharmaceuticals",
        "Real Estate",
        "Restaurant",
        "Retail",
        "Sales and Customer Service",
        "Science and Research",
        "Software and Development",
        "Sports and Recreation",
        "Telecommunications",
        "Transportation"
    ]
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
                                    Text(locationText)
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
            fetchUserLocation()
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

                let settings = data["work_setting"] as? [String] ?? []
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

    private func fetchUserLocation() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                if let geoPoint = data["location"] as? GeoPoint {
                    let location = CLLocation(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                    geocodeLocation(location: location)
                } else {
                    locationText = "Location not set"
                }
            } else {
                locationText = "Location not set"
            }
        }
    }

    private func geocodeLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                locationText = "\(city), \(state)"
            } else {
                locationText = "Location not found"
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
#Preview {
    ToggleView()
}
