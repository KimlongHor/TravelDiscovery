//
//  RestaurantDetailsView.swift
//  TravelDiscovery
//
//  Created by horkimlong on 5/8/21.
//

import SwiftUI
import Kingfisher

struct RestaurantDetails: Decodable {
    let description: String
    let popularDishes: [Dish]
    let photos: [String]
    let reviews: [Review]
}

struct Review: Decodable, Hashable {
    let user: ReviewUser
    let rating: Int
    let text: String
}

struct ReviewUser: Decodable, Hashable {
    let id: Int
    let username, firstName, lastName, profileImage: String
}

struct Dish: Decodable, Hashable{
    let name: String
    let price: String
    let numPhotos: Int
    let photo: String
}

class RestaurantDetailsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var details: RestaurantDetails?
    
    init() {
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/restaurant?id=0"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch API - RestaurantDetailsView", error)
                return
            }
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    self.details = try JSONDecoder().decode(RestaurantDetails.self, from: data)
                } catch {
                    print("Failed to decode JSON- RestaurantDetailsView", error)
                }
            }
            
        }.resume()
    }
}

struct RestaurantDetailsView: View {
    
    let restaurant: Restaurant
    @ObservedObject var vm = RestaurantDetailsViewModel()
    
    var body: some View {
        ScrollView {
            
            HeaderView(restaurant: restaurant)
            
            if let description = vm.details?.description  {
                LocationAndDescriptionView(description: description)
            }
            
            if let popularDishes = vm.details?.popularDishes {
                PopularDishesList(popularDishes: popularDishes)
            }
            
            if let reviews = vm.details?.reviews {
                ReviewsList(reviews: reviews)
            }
            
            
        }
        .navigationBarTitle("Restaurant Details", displayMode: .inline)
    }
}

struct PopularDishesList: View {
    
    let popularDishes: [Dish]
    
    var body: some View {
        HStack {
            Text("Popular Dishes")
                .font(.system(size: 16, weight: .bold))
            
            Spacer()
        }.padding(.horizontal)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(popularDishes, id: \.self) { dish in
                    DishCell(dish: dish)
                }
            }.padding(.horizontal)
        }
        
    }
}

struct LocationAndDescriptionView: View {
    let description: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Location & Description")
                .font(.system(size: 16, weight: .bold))
            Text("Tokyo, Japan")
            
            HStack {
                ForEach(0..<5, id: \.self) { num in
                    Image(systemName: "dollarsign.circle.fill")
                }.foregroundColor(.orange)
            }
            
            HStack{ Spacer() }
        }.padding(.top)
        .padding(.horizontal)
        
        Text(description)
            .padding(.top, 8)
            .font(.system(size: 14, weight: .regular))
            .padding(.horizontal)
            .padding(.bottom)
    }
}

struct ReviewsList: View {
    let reviews: [Review]
    
    var body: some View {
        HStack {
            Text("Customer Reviews")
                .font(.system(size: 16, weight: .bold))
            
            Spacer()
        }.padding(.horizontal)
        .padding(.top, 8)
        
        
        ForEach(reviews, id: \.self) { review in
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    KFImage(URL(string: review.user.profileImage))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text("\(review.user.firstName) \(review.user.lastName)")
                            .font(.system(size: 14, weight: .bold))
                        
                        HStack(spacing: 4){
                            ForEach(0..<review.rating, id: \.self) { num in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                            }
                            
                            ForEach(0..<5 - review.rating, id: \.self) { num in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .font(.system(size: 12))
                    }
                    
                    Spacer()
                    
                    Text("Dec 2020")
                        .font(.system(size: 14, weight: .bold))
                }
                
                Text(review.text)
                    .font(.system(size: 14, weight: .regular))
            }
            .padding(.top)
            .padding(.horizontal)
            
        }
        
    }
}


struct HeaderView: View {
    let restaurant: Restaurant
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(restaurant.imageName)
                .resizable()
                .scaledToFill()
            
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(restaurant.name)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                    
                    HStack {
                        ForEach(0..<5, id: \.self) { num in
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                Spacer()
                
                NavigationLink(
                    destination: RestaurantPhotosView(),
                    label: {
                        Text("See more photos")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .regular))
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    })
                
            }.padding()
        }
    }
}

struct DishCell: View {
    let dish: Dish
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ZStack(alignment: .bottomLeading) {
                KFImage(URL(string: dish.photo))
                    .resizable()
                    .scaledToFill()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .shadow(radius: 2)
                    .padding(.vertical, 2)
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                
                Text(dish.price)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.bottom, 4)
            }
            .frame(height: 120)
            .cornerRadius(5)
            
            
            Text(dish.name)
                .font(.system(size: 14, weight: .bold))
            Text("\(dish.numPhotos) photos")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.gray)
        }
    }
    
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailsView(restaurant: .init(name: "Japan's Finest Tapas", imageName: "tapas"))
    }
}
