//
//  DishDetail.swift
//  LittleLemon
//
//  Created by Chuka Uwefoh on 2026-07-27.
//

import SwiftUI
import CoreData

struct DishDetail: View {
    let dish: Dish
    @Environment(\.presentationMode) var presentationMode
    
    // Little Lemon Colors
    let primaryGreen = Color(red: 0.28, green: 0.60, blue: 0.58)
    let darkGreen = Color(red: 0.29, green: 0.37, blue: 0.34)
    let brightYellow = Color(red: 0.96, green: 0.80, blue: 0.08)
    let lightBg = Color(red: 0.97, green: 0.96, blue: 0.94)
    
    var body: some View {
        ZStack {
            lightBg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Dish Image
                    if let imageURLString = dish.image,
                       let imageURL = URL(string: imageURLString) {
                        AsyncImage(url: imageURL) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 280)
                                    .clipped()
                                    .cornerRadius(16)
                            } else if phase.error != nil {
                                Image(systemName: "photo")
                                    .frame(height: 280)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(16)
                            } else {
                                ProgressView()
                                    .frame(height: 280)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title
                        Text(dish.title ?? "")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(darkGreen)
                        
                        // Price Badge
                        if let price = dish.price {
                            HStack {
                                Text("$\(price)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(primaryGreen)
                                    .cornerRadius(8)
                                
                                Spacer()
                            }
                        }
                        
                        Divider()
                            .frame(height: 2)
                            .background(brightYellow)
                        
                        // Description Section
                        if let description = dish.dishDescription {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("About")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(darkGreen)
                                
                                Text(description)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                                    .lineLimit(nil)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            }
                        }
                        
                        Spacer()
                        
                        // Add to Cart Button
                        Button(action: addToCart) {
                            HStack {
                                Image(systemName: "cart.badge.plus")
                                Text("Add to Cart")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(primaryGreen)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Dish Details")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(darkGreen)
            }
        }
    }
    
    private func addToCart() {
        print("Added \(dish.title ?? "dish") to cart")
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let sampleDish = Dish(context: context)
    sampleDish.title = "Greek Salad"
    sampleDish.price = "12.99"
    sampleDish.image = "https://github.com/Meta-Mobile-Developer-PC/Working-With-Data-API/blob/main/images/greek_salad.jpg?raw=true"
    sampleDish.dishDescription = "A refreshing and authentic Greek salad featuring crisp lettuce, ripe tomatoes, cucumbers, olives, and feta cheese. Topped with our signature olive oil vinaigrette."
    
    return NavigationView {
        DishDetail(dish: sampleDish)
    }
}
