//
//  Menu.swift
//  LittleLemon
//
//  Created by Chuka Uwefoh on 2026-07-27.
//
import SwiftUI

struct Menu: View {
    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text("Little Lemon")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Location
            Text("Chicago")
                .font(.headline)
                .foregroundColor(.gray)
            
            // Description
            Text("Experience authentic Mediterranean cuisine in the heart of Chicago. Fresh ingredients, bold flavors, and a warm atmosphere await you.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            // Menu List (placeholder for items)
            List {
                // Menu items will be populated here from Core Data
            }
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    Menu()
}
