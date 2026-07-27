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
    
    
    var body: some View {
        NavigationView {
            VStack{
                VStack(spacing: 8) {
                    Text("Welcome to Little Lemon")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Create your account to get started")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding(.bottom, 20)
                
                Spacer()
                
                NavigationLink(destination: Home(), isActive: $isLoggedIn) {
                                   EmptyView()
                               }
                
                //Textfileds
                
                VStack(spacing: 16){
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled(true)
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled(true)
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    
                    
                }
                .padding(.horizontal, 20)
                Spacer()
                
                //Register Button
                Button(action: registerUser){
                    Text("Register")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.27, green: 0.61, blue: 0.58))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding(.vertical, 20)
            .onAppear {
                if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                    isLoggedIn = true
                }
            }
                        .alert("Registration", isPresented: $showAlert) {
                            Button("OK") {}
                        } message: {
                            Text(alertMessage)
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
    
#Preview {
    Onboarding()
}
