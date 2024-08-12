//
//  MainView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// Custom shape for the next profile. It is a rectangle with only the top two corners rounded.
struct TopCornersRounded: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Main view
struct MainView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    // Variables to show the pricing/toggle and filling icons
    @State private var showTierView = false
    @State private var showSearchSettings = false
    @State private var showOverlay = false
    @State private var likesRemaining = 0
    @State private var step = 0
    @State private var recommendationUserId: String = ""

    var body: some View {
        NavigationView {
            // ZStack with Background
            ZStack {
                BackgroundView()
                // VStack with the rest of the page content
                VStack {
                    // Top Area
                    HStack {
                        // HStack with the number of likes remaining
                        HStack {
                            Image(systemName: "heart.fill").foregroundColor(.red).padding(.all, 5.0).font(.system(size: 25))
                            Text("\(likesRemaining)").font(.title).padding(.trailing, 5.0)
                        }
                        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))
                        .padding(.leading, 27.0).padding(.top, 70)

                        Spacer()

                        Image("Duck_Head").resizable().aspectRatio(contentMode: .fit).frame(width: 120).padding(.top, 10.0)
                        // Stack with the tiers and toggle buttons
                        VStack {
                            // Needs to be dynamic for employees or employers
                            Button(action: {
                                showTierView.toggle()
                            }) {
                                Image(systemName: "bag").foregroundColor(Color.white).font(.system(size: 45)).padding(.horizontal, 27.0).padding(.bottom, 10.0)
                            }

                            Button(action: {
                                showSearchSettings.toggle()
                            }) {
                                Image("adjust")
                            }
                        }
                    }.padding(.trailing, 20.0)

                    // Main Area
                    ZStack {
                        // Background white
//                        Rectangle()
//                            .fill(Color.white)
//                            .frame(width: 395, height: 545)
//                            .cornerRadius(10).padding(.top, -20)

                        // Display profile card based on user type and recommendation
                        if !recommendationUserId.isEmpty {
                            if appViewModel.userType == 0 {
                                ProfileCardViewEmployer(currentStep: $step, userId: $recommendationUserId)
                            } else {
                                ProfileCardView(currentStep: $step, userId: $recommendationUserId)
                            }
                        } else {
                            Text("No recommendations available")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                    }.padding([.top, .leading, .trailing]).padding(.bottom, 5)

                    // Next Profile
                    TopCornersRounded(radius: 10)
                        .fill(Color.white)
                        .frame(height: 20)
                        .padding([.leading, .trailing])

                    Spacer()
                    Spacer()
                }

                // Overlay and Report button
                if showOverlay {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showOverlay.toggle()
                        }

                    VStack {
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                // Handle report action
                            }) {
                                HStack {
                                    Image(systemName: "exclamationmark.circle")
                                        .foregroundColor(.red)
                                    Text("Report")
                                        .foregroundColor(.red)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                            }
                            .padding()
                        }.padding(.trailing, 10)
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showTierView) {
                if appViewModel.userType == 1 {
                    EmployerTiersView()
                } else {
                    EmployeeTierView()
                }
            }
            .sheet(isPresented: $showSearchSettings) {
                if appViewModel.userType == 1 {
                    ToggleViewEmployer()
                } else {
                    ToggleView()
                }
            }
            .onAppear {
                fetchUserDetails()
            }
        }
    }

    private func fetchUserDetails() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.likesRemaining = data?["likes_remaining"] as? Int ?? 0
                self.recommendationUserId = (data?["recommendations"] as? [String])?.first ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }
}

#Preview {
    MainView()
}
