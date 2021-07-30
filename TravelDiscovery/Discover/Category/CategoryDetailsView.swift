//
//  CategoryDetailsView.swift
//  TravelDiscovery
//
//  Created by horkimlong on 29/7/21.
//

import SwiftUI
import Kingfisher
import SDWebImageSwiftUI


class CategoryDetailsViewModel: ObservableObject {
    
    // A view model is an object that the view looks at in order to figure out what to display
    
    // for variables that the UI observes at, we need to put @Published in front.
    @Published var isLoading = true
    @Published var places = [Place]()
    @Published var errorMessage = ""
    
    init() {
        // network code will happen here
        
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/category?name=art") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed fetching from LBTA", error)
                return
            }
            
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    self.places = try JSONDecoder().decode([Place].self, from: data)
                } catch {
                    print("Failed to decode JSON:", error)
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }.resume()
    }
}

struct CategoryDetailsView: View {
    @ObservedObject var vm = CategoryDetailsViewModel()
    
    var body: some View {
        
        ZStack {
            if vm.isLoading {
                VStack {
                    ActivityIndicatorView()
                    Text("Loading...")
                        .foregroundColor(Color.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding()
                .background(Color.black)
                .cornerRadius(8)
            } else {
                ZStack {
                    Text(vm.errorMessage)
                    ScrollView {
                        ForEach(vm.places, id: \.self) {  place in
                            VStack(alignment: .leading, spacing: 0) {
                                KFImage(URL(string: place.thumbnail))
                                    .resizable()
                                    .scaledToFill()
                                Text(place.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding()
                            }.asTile()
                            .padding()
                        }
                    }
                    
                }
                
            }
        }
        .navigationBarTitle("Category", displayMode: .inline)
    }
}

struct CategoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailsView()
    }
}
