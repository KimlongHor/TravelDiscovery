//
//  ContentView.swift
//  TravelDiscovery
//
//  Created by horkimlong on 26/7/21.
//

import SwiftUI

extension Color {
    static let discoverBackground = Color(.init(white: 0.95, alpha: 1))
    static let defaultBackground = Color("defaultBackground")
    static let tileBackground = Color("tileBackground")
}

struct DiscoverView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    @Environment(\.colorScheme) var colorScheme
     
    var body: some View {
        NavigationView {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.7442571699, blue: 0.258888263, alpha: 1)), Color(#colorLiteral(red: 0.9582416162, green: 0.6059363385, blue: 0.2683993525, alpha: 1))]), startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
                
                Color.discoverBackground
                    .offset(y: 400)
                
                ScrollView {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Where do you want to go?")
                        Spacer()
                    }.font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.init(white: 1, alpha: 0.3)))
                    .cornerRadius(12)
                    .padding(16)
                    
                    DiscoverCategoriesView()
                    
                    VStack {
                        PopularDestinationsView()
                        PopularRestaurantsView()
                        TrendingCreatorsView()
                    }.background(Color.defaultBackground)
                    .cornerRadius(16)
                    .padding(.top, 32)
                    
                }.navigationTitle("Discover")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
