//
//  Onboarding.swift
//  LittleLemon
//
//  Created by Chuka Uwefoh on 2026-07-27.
//

//
//  Onboarding.swift
//  LittleLemon
//
//  Created by Chuka Uwefoh on 2026-07-27.
//

import SwiftUI
import CoreData

let kFirstName = "first_name_key"
let kLastName = "last_name_key"
let kEmail = "email_key"
let kIsLoggedIn = "kIsLoggedIn"

struct Onboarding: View {
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    
    // Little Lemon Colors
    let primaryGreen = Color(red: 0.28, green: 0.60, blue: 0.58)
    let darkGreen = Color(red: 0.29, green: 0.37, blue: 0.34)
    let brightYellow = Color(red: 0.96, green: 0.80, blue: 0.08)
    let lightBg = Color(red: 0.97, green: 0.96, blue: 0.94)
    
    var body: some View {
        NavigationView {
            ZStack {
                lightBg.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Little Lemon")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(primaryGreen)
                        
                        Text("Welcome")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(darkGreen)
                        
                        Text("Create your account to get started")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: Home(), isActive: $isLoggedIn) {
                        EmptyView()
                    }
                    
                    Spacer()
                    
                    // Text Fields
                    VStack(spacing: 14) {
                        CustomTextField(
                            label: "First Name",
                            placeholder: "Enter your first name",
                            text: $firstName
                        )
                        
                        CustomTextField(
                            label: "Last Name",
                            placeholder: "Enter your last name",
                            text: $lastName
                        )
                        
                        CustomTextField(
                            label: "Email",
                            placeholder: "Enter your email",
                            text: $email,
                            keyboardType: .emailAddress
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Register Button
                    Button(action: registerUser) {
                        Text("Register")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(primaryGreen)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
                .padding(.vertical, 20)
                .alert("Registration", isPresented: $showAlert) {
                    Button("OK") {}
                } message: {
                    Text(alertMessage)
                }
            }
        }
        .onAppear {
            if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                isLoggedIn = true
            }
        }
    }
    
    // MARK: - Registration Logic
    private func registerUser() {
        // Validate that all fields are not empty
        guard !firstName.isEmpty else {
            alertMessage = "Please enter your first name"
            showAlert = true
            return
        }
        
        guard !lastName.isEmpty else {
            alertMessage = "Please enter your last name"
            showAlert = true
            return
        }
        
        guard !email.isEmpty else {
            alertMessage = "Please enter your email"
            showAlert = true
            return
        }
        
        // Validate email format
        guard isValidEmail(email) else {
            alertMessage = "Please enter a valid email address"
            showAlert = true
            return
        }
        
        // Store data in UserDefaults
        UserDefaults.standard.set(firstName, forKey: kFirstName)
        UserDefaults.standard.set(lastName, forKey: kLastName)
        UserDefaults.standard.set(email, forKey: kEmail)
        UserDefaults.standard.set(true, forKey: kIsLoggedIn)
        
        // Navigate to home screen
        isLoggedIn = true
    }
    
    // MARK: - Email Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let regex = try? NSRegularExpression(pattern: emailPattern)
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex?.firstMatch(in: email, range: range) != nil
    }
}

// MARK: - Custom TextField
struct CustomTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    let primaryGreen = Color(red: 0.28, green: 0.60, blue: 0.58)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(primaryGreen)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled()
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(primaryGreen.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

#Preview {
    Onboarding()
}
