//
//  firstView.swift
//  Peeking
//
//  Created by Will kaminski on 7/1/24.
//

import SwiftUI
import _AuthenticationServices_SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth


struct firstView: View {
    @State private var showSignInView: Bool = false
    @State private var isProfileSetupComplete: Bool = false
    var body: some View {
        NavigationStack {
            NavigationLink(destination: PhoneAuthView(showSignInView: $showSignInView, isProfileSetupComplete: $isProfileSetupComplete)) {
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("Employer")
                            .font(.title3)
                            .foregroundColor(Color.white)
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }.background(Color.blue)
            }
            
            SignInWithAppleButton(onRequest: { request in
                //handleSignInWithAppleRequest(request)
            }, onCompletion: { result in
               //handleSignInWithAppleCompletion(result)
            })
                .frame(height:55)
                .cornerRadius(8)
            
            
        }
    }
}

#Preview {
    firstView()
}
