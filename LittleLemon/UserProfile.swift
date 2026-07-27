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
    
    // Little Lemon Colors
    let primaryGreen = Color(red: 0.28, green: 0.60, blue: 0.58)
    let darkGreen = Color(red: 0.29, green: 0.37, blue: 0.34)
    let brightYellow = Color(red: 0.96, green: 0.80, blue: 0.08)
    let lightBg = Color(red: 0.97, green: 0.96, blue: 0.94)
    
    var body: some View {
        ZStack {
            lightBg.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 20) {
                // Title
                Text("Personal Information")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(darkGreen)
                    .padding(.top, 20)
                
                // Profile Picture Placeholder
                Image("profile-image-placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(primaryGreen, lineWidth: 3)
                    )
                    .padding(.vertical, 10)
                
                // User Information Card
                VStack(alignment: .leading, spacing: 16) {
                    UserInfoRow(label: "First Name", value: firstName, color: primaryGreen)
                    Divider()
                    UserInfoRow(label: "Last Name", value: lastName, color: primaryGreen)
                    Divider()
                    UserInfoRow(label: "Email", value: email, color: primaryGreen)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Logout Button
                Button(action: logout) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left")
                        Text("Logout")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(red: 0.83, green: 0.19, blue: 0.19))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
        }
    }
    
    // MARK: - Logout Logic
    private func logout() {
        UserDefaults.standard.set(false, forKey: kIsLoggedIn)
        self.presentation.wrappedValue.dismiss()
    }
}

// MARK: - Helper View
struct UserInfoRow: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(color)
                .textCase(.uppercase)
            
            Text(value)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    UserProfile()
}
