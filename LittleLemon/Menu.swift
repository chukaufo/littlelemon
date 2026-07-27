//
//  Menu.swift
//  LittleLemon
//
//  Created by Chuka Uwefoh on 2026-07-27.
//


import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    
    // Little Lemon Colors
    let primaryGreen = Color(red: 0.28, green: 0.60, blue: 0.58)  // Teal
    let darkGreen = Color(red: 0.29, green: 0.37, blue: 0.34)     // Dark green
    let brightYellow = Color(red: 0.96, green: 0.80, blue: 0.08)  // Yellow
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.97, green: 0.96, blue: 0.94).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Little Lemon")
                        .font(.system(size: 42, weight: .bold, design: .default))
                        .foregroundColor(primaryGreen)
                    
                    Text("Chicago")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(darkGreen)
                    
                    Text("Experience authentic Mediterranean cuisine in the heart of Chicago. Fresh ingredients, bold flavors, and a warm atmosphere await you.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .background(Color.white)
                
                Divider()
                    .frame(height: 1)
                    .background(brightYellow)
                
                // Search Field
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(primaryGreen)
                        
                        TextField("Search menu", text: $searchText)
                            .textFieldStyle(.plain)
                            .font(.system(size: 16))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(primaryGreen, lineWidth: 1.5)
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.white)
                
                // Menu List
                FetchedObjects<Dish, AnyView>(
                    predicate: buildPredicate(),
                    sortDescriptors: buildSortDescriptors()
                ) { (dishes: [Dish]) in
                    AnyView(
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(dishes, id: \.self) { dish in
                                    NavigationLink(destination: DishDetail(dish: dish)) {
                                        HStack(spacing: 16) {
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(dish.title ?? "")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(darkGreen)
                                                
                                                if let price = dish.price {
                                                    Text("$\(price)")
                                                        .font(.system(size: 16, weight: .bold))
                                                        .foregroundColor(primaryGreen)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            if let imageURLString = dish.image,
                                               let imageURL = URL(string: imageURLString) {
                                                AsyncImage(url: imageURL) { phase in
                                                    if let image = phase.image {
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 90, height: 90)
                                                            .cornerRadius(12)
                                                            .clipped()
                                                    } else if phase.error != nil {
                                                        Image(systemName: "photo")
                                                            .frame(width: 90, height: 90)
                                                            .background(Color.gray.opacity(0.2))
                                                            .cornerRadius(12)
                                                            .foregroundColor(.gray)
                                                    } else {
                                                        ProgressView()
                                                            .frame(width: 90, height: 90)
                                                            .background(Color.gray.opacity(0.1))
                                                            .cornerRadius(12)
                                                    }
                                                }
                                            }
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(primaryGreen)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                    )
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }
    
    // MARK: - Sorting
    private func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        ]
    }
    
    // MARK: - Filtering
    private func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
    
    // MARK: - Fetch Menu Data
    private func getMenuData() {
        // Clear database before fetching new data
        PersistenceController.shared.clear()
        
        // Define server URL
        let serverUrlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        
        guard let url = URL(string: serverUrlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            // Parse JSON response
            if let data = data {
                let decoder = JSONDecoder()
                
                if let result = try? decoder.decode(MenuList.self, from: data) {
                    // Convert MenuItems to Dish entities and save to Core Data
                    for item in result.menu {
                        let dish = Dish(context: viewContext)
                        dish.title = item.title
                        dish.image = item.image
                        dish.price = item.price
                        if let description = item.description {
                            dish.dishDescription = description
                        }
                    }
                    
                    // Save to database
                    do {
                        try viewContext.save()
                        print("Menu data saved successfully")
                    } catch {
                        print("Error saving to Core Data: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        task.resume()
    }
}

#Preview {
    Menu()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
