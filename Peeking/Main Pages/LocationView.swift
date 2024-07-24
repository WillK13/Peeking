//
//  LocationView.swift
//  Peeking
//
//  Created by Will kaminski on 7/24/24.
//

import SwiftUI
import MapKit
import FirebaseAuth
import FirebaseFirestore

// New view when expanding location
struct LocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isGeocoding = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.3601, longitude: 71.0589), // Boston, MA coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedLocation: MKLocalSearchCompletion?
    @State private var annotations: [IdentifiablePointAnnotation] = []

    private var searchCompleter = MKLocalSearchCompleter()
    @StateObject private var searchCompleterDelegate = LocationSearchCompleterDelegate()
    
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
            
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, userTrackingMode: .none, annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    Circle()
                        .stroke(Color.orange, lineWidth: 3)
                        .frame(width: 10, height: 10)
                }
            }
            .mapStyle(.standard) // Using standard map style as mutedStandard is not available
            .frame(height: 200)
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Search bar for location
            VStack(alignment: .leading, spacing: 15) {
                Text("Search Location")
                TextField("Enter location", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 5)
                    .onChange(of: searchQuery) { newValue in
                        searchCompleter.queryFragment = newValue
                    }
                
                // Display search results
                List(searchResults, id: \.self) { result in
                    Button(action: {
                        selectLocation(result)
                    }) {
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.body)
                                .foregroundColor(.black)
                            Text(result.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .listRowBackground(Color.clear) // Removing default gray background
                }
                .frame(height: 150)
                .background(Color.clear)
            }
//            .padding()
            
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
        .onAppear {
            fetchCurrentLocation()
            setupSearchCompleter()
        }
    }
    
    private func setupSearchCompleter() {
        searchCompleter.delegate = searchCompleterDelegate
        searchCompleterDelegate.updateResults = { results in
            self.searchResults = results
        }
    }
    
    private func fetchCurrentLocation() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                if let geoPoint = data["location"] as? GeoPoint {
                    let location = CLLocation(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                    region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                    annotations = [IdentifiablePointAnnotation(__coordinate: location.coordinate)]
                }
            }
        }
    }
    
    private func selectLocation(_ result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
            } else if let response = response, let item = response.mapItems.first {
                let coordinate = item.placemark.coordinate
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                annotations = [IdentifiablePointAnnotation(__coordinate: coordinate)]
                selectedLocation = result
            }
        }
    }
    
    private func saveLocation() {
        guard let selectedLocation = selectedLocation else {
            alertMessage = "Please select a location."
            showingAlert = true
            return
        }
        
        let searchRequest = MKLocalSearch.Request(completion: selectedLocation)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
            } else if let response = response, let item = response.mapItems.first {
                let location = item.placemark.location
                updateLocationInFirestore(location: location!)
            }
        }
    }
    
    private func updateLocationInFirestore(location: CLLocation) {
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

// Conforming MKPointAnnotation to Identifiable
class IdentifiablePointAnnotation: MKPointAnnotation, Identifiable {
    let id = UUID()
}

class LocationSearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate, ObservableObject {
    @Published var updateResults: ([MKLocalSearchCompletion]) -> Void = { _ in }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        updateResults(completer.results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Handle error
        print("Error with search completer: \(error.localizedDescription)")
    }
}

#Preview {
    LocationView()
}
