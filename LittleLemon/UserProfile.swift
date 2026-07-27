//
//  UserProfile.swift
//  LittleLemon
//
//  Created by Chuka Uwefoh on 2026-07-27.
//

import SwiftUI

struct UserProfile: View {
    
    @Environment(\.presentationMode) var presentation
    
    // Retrieve user data from UserDefaults
    let firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    let lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    let email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Title
            Text("Personal information")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Profile Image Placeholder
            Image("profile-image-placeholder")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.vertical, 20)
            
            // User Information
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("First Name:")
                        .fontWeight(.semibold)
                    Text(firstName)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Last Name:")
                        .fontWeight(.semibold)
                    Text(lastName)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Email:")
                        .fontWeight(.semibold)
                    Text(email)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Logout Button
            Button(action: logout) {
                Text("Logout")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.27, green: 0.61, blue: 0.58))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            
            Spacer()
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Logout Logic
    private func logout() {
        UserDefaults.standard.set(false, forKey: kIsLoggedIn)
        self.presentation.wrappedValue.dismiss()
    }
}

#Preview {
    UserProfile()
}
