//
//  ProfileSearchSettings.swift
//  Peeking
//
//  Created by Will kaminski on 6/14/24.
//

import SwiftUI
import FirebaseAuth
import CoreLocation
import MapKit
import FirebaseFirestore

struct ProfileSearchSettings: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var distance: Double = 30
    @State private var showLocationView = false
    @State private var locationText: String = "Loading..."
    @State private var userLocation: CLLocationCoordinate2D?
    
    @State private var selectedField1 = "Choose"
    @State private var selectedField2 = "Choose"
    @State private var selectedField3 = "Choose"
    
    @State private var selectedEmployer1 = "Choose"
    @State private var selectedEmployer2 = "Choose"
    @State private var selectedEmployer3 = "Choose"
    
    @State private var selectedSetting1 = "Choose"
    @State private var selectedSetting2 = "Choose"
    @State private var selectedSetting3 = "Choose"
    
    @State private var selectedStatus1 = "Choose"
    @State private var selectedStatus2 = "Choose"
    @State private var selectedStatus3 = "Choose"
    
    @State private var selectedStart1 = "Choose"
    @State private var selectedStart2 = "Choose"
    @State private var selectedStart3 = "Choose"
    
    @State private var navigateToNextView: Bool = false

    var fieldOptions = ["Consulting", "IT Consulting", "Management Consulting"]
    var employerOptions = ["Startup", "Small Business", "Independent Client", "Corporate"]
    var workSettingOptions = ["Remote", "In-Person", "Hybrid"]
    var employmentStatusOptions = ["Part-time", "Full-Time", "Temporary", "Internship"]
    var startOptions = ["Fall", "Winter", "Spring", "Summer", "Any"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
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
                }
                .background(Color("TopOrange"))
                .cornerRadius(10)

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

                        selectionSection(title: "Field/Niche", selectedOptions: [$selectedField1, $selectedField2, $selectedField3], options: fieldOptions)
                        Divider().background(Color.gray)
                        selectionSection(title: "Type of Employer", selectedOptions: [$selectedEmployer1, $selectedEmployer2, $selectedEmployer3], options: employerOptions)
                        Divider().background(Color.gray)
                        selectionSection(title: "Work Setting", selectedOptions: [$selectedSetting1, $selectedSetting2, $selectedSetting3], options: workSettingOptions)
                        Divider().background(Color.gray)
                        selectionSection(title: "Employment Status", selectedOptions: [$selectedStatus1, $selectedStatus2, $selectedStatus3], options: employmentStatusOptions)
                        Divider().background(Color.gray)
                        selectionSection(title: "Start Time", selectedOptions: [$selectedStart1, $selectedStart2, $selectedStart3], options: startOptions)
                        Divider().background(Color.gray)

                        HStack {
                            Spacer()
                            NavigationLink(destination: TechnicalsEmployee(fromEditProfile: false), isActive: $navigateToNextView) {
                                Button(action: {
                                    Task {
                                        await saveProfileSettings()
                                    }
                                }) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color("BottomOrange"))
                                        .cornerRadius(25)
                                        .opacity(isFormComplete() ? 1.0 : 0.5)
                                }
                                .disabled(!isFormComplete())
                                .padding(.top, 20)
                            }.disabled(!isFormComplete())
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.bottom, 20)
                }
                .navigationBarBackButtonHidden(true)
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            fetchUserLocation()
        }
        .onChange(of: showLocationView) { newValue in
            if !newValue {
                fetchUserLocation()
            }
        }
    }
    
    func selectionSection(title: String, selectedOptions: [Binding<String>], options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
            HStack {
                ForEach(0..<selectedOptions.count, id: \.self) { index in
                    Spacer()
                    DropdownMenuButtonStart(title: selectedOptions[index], options: options)
                }
            }
        }
        .padding()
    }

    func isFormComplete() -> Bool {
        return selectedField1 != "Choose" && selectedField2 != "Choose" && selectedField3 != "Choose" &&
               selectedEmployer1 != "Choose" && selectedEmployer2 != "Choose" && selectedEmployer3 != "Choose" &&
               selectedSetting1 != "Choose" && selectedSetting2 != "Choose" && selectedSetting3 != "Choose" &&
               selectedStatus1 != "Choose" && selectedStatus2 != "Choose" && selectedStatus3 != "Choose" &&
               selectedStart1 != "Choose" && selectedStart2 != "Choose" && selectedStart3 != "Choose" &&
               locationText != "Location not set" && locationText != "Location not found"
    }

    func saveProfileSettings() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let fields = [selectedField1, selectedField2, selectedField3]
        let employers = [selectedEmployer1, selectedEmployer2, selectedEmployer3]
        let workSettings = [selectedSetting1, selectedSetting2, selectedSetting3]
        let statuses = [selectedStatus1, selectedStatus2, selectedStatus3]
        let startTimes = [selectedStart1, selectedStart2, selectedStart3]

        let _: [String: Any] = [
            "distance": Int(distance),
            "fields": fields,
            "employer": employers,
            "workSetting": workSettings,
            "status": statuses,
            "start": startTimes
        ]

        do {
            try await ProfileUpdater.shared.updateProfileSettings(userId: userId, distance: Int(distance), fields: fields, employer: employers, workSetting: workSettings, status: statuses, start: startTimes)
            navigateToNextView = true
        } catch {
            // Handle error
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
                locationText = city.isEmpty && state.isEmpty ? "Location not found" : "\(city), \(state)"
                userLocation = location.coordinate
            } else {
                locationText = "Location not found"
                userLocation = nil
            }
        }
    }
}

// Drop down menu for each button with the custom items above
struct DropdownMenuButtonStart: View {
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
                .background(Color.orange.opacity(title == "Choose" ? 0.5 : 0.7))
                .cornerRadius(10)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

struct ProfileSearchSettings_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSearchSettings()
    }
}
