//
//  MainView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SwiftUIPager

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
    @State private var recommendationUserIds: [String] = []
    @State private var currentIndex = 0

    @State private var page: Page = .first()

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    // Top Area
                    HStack {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .padding(.all, 5.0)
                                .font(.system(size: 25))
                            Text("\(likesRemaining)")
                                .font(.title)
                                .padding(.trailing, 5.0)
                        }
                        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))
                        .padding(.leading, 27.0)
                        .padding(.top, 70)

                        Spacer()

                        Image("Duck_Head")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120)
                            .padding(.top, 15.0)
                        
                        VStack {
                            Button(action: {
                                showTierView.toggle()
                            }) {
                                Image(systemName: "bag")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 45))
                                    .padding(.horizontal, 27.0)
                                    .padding(.bottom, 10.0)
                            }

                            Button(action: {
                                showSearchSettings.toggle()
                            }) {
                                Image("adjust")
                            }
                        }
                    }
                    .padding(.trailing, 20.0)
//                    .padding(.top, 30)

                    // Main Area
                    Pager(page: page, data: recommendationUserIds.indices, id: \.self) { index in
                        VStack {
                            if appViewModel.userType == 0 {
                                ProfileCardViewEmployer(currentStep: $step, userId: .constant(recommendationUserIds[index]))
                            } else {
                                ProfileCardView(currentStep: $step, userId: .constant(recommendationUserIds[index]))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
//                        .shadow(radius: 10)
                        /*.padding(.vertical, 10)*/ // Add padding to separate the cards
                    }
                    .vertical()
                    .onPageChanged { newIndex in
                        if newIndex == recommendationUserIds.count - 1 {
                            fetchMoreRecommendations()
                        }
                    }
//                    .padding(.top, -10)
//                    .padding(.horizontal)

                    // Next Profile
                    TopCornersRounded(radius: 10)
                        .fill(Color.gray)
                        .frame(height: 20)
                        .blur(radius: 3)
                        .padding(.top, -5)
//                        .padding([.leading, .trailing])
//                        .padding(.bottom, 20)

                    Spacer()
                }

                if showOverlay {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showOverlay.toggle()
                        }

                    VStack {
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
                self.recommendationUserIds = data?["recommendations"] as? [String] ?? []
                self.currentIndex = 0
            } else {
                print("Document does not exist")
            }
        }
    }

    private func fetchMoreRecommendations() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        APIClient.shared.match(userId: userId, userType: appViewModel.userType ?? 0) { result in
            switch result {
            case .success(let newRecommendations):
//                if !newRecommendations.isEmpty {
//                    self.recommendationUserIds.append(contentsOf: newRecommendations)
//                }
                print("Hi")
            case .failure(let error):
                print("Failed to fetch more recommendations: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    MainView()
}
