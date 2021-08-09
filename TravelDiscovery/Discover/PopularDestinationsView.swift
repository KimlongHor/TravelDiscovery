//
//  PopularDestinationsView.swift
//  TravelDiscovery
//
//  Created by horkimlong on 27/7/21.
//

import SwiftUI
import MapKit

struct PopularDestinationsView: View {
    let destinations: [Destination] = [
        .init(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.859565, longitude: 2.353235),
        .init(name: "Tokyo", country: "Japan", imageName: "japan", latitude: 35.679793, longitude: 139.771913),
        .init(name: "New York", country: "US", imageName: "new_york", latitude: 40.71592, longitude: -74.0055)
    ]
    
    var body: some View {
        VStack{
            HStack {
                Text("Popular destinations")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(destinations, id: \.self) { destination in
                        NavigationLink(
                            destination: NavigationLazyView(PopularDestinationDetailsView(destination: destination)),
                            label: {
                                PopularDestinationTile(destination: destination)
                                    .padding(.bottom)
                            }
                        )
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct DestinationDetails: Decodable {
    let description: String
    let photos: [String]
}

class DestinationDetailsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var destinationDetails: DestinationDetails?
    
    init(name: String) {
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch data from LBTA - PopularDestinationDetailView", error)
                return
            }
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    self.destinationDetails = try JSONDecoder().decode(DestinationDetails.self, from: data)
                } catch {
                    print("Failed to decode JSON:", error)
                }
            }
        }.resume()
    }
}

struct PopularDestinationDetailsView: View {
    
    let destination: Destination
    
    // we put @State before the region variable because it is a binding variable, which means every time we move the map, this variable keeps changing.
    @State var region: MKCoordinateRegion
    @State var isShowingAttractions = false
    
    @ObservedObject var vm: DestinationDetailsViewModel
    
    let attractions: [Attraction] = [
        .init(name: "Eiffel Tower", imageName: "eiffel_tower", latitude: 48.858605, longitude: 2.2946),
        .init(name: "Champs-Elysees", imageName: "new_york", latitude: 48.866867, longitude: 2.311780),
        .init(name: "Louvre Museum", imageName: "art2", latitude: 48.860288, longitude: 2.337789)
    ]
    
    init(destination: Destination) {
        self.destination = destination
        self.vm = .init(name: destination.name)
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }
    
    var body: some View {
        ScrollView {
            
            if let photos = vm.destinationDetails?.photos {
                DestinationHeaderContainer(imageUrlStrings:  photos)
                    .frame(height: 350)
            }
            
            VStack(alignment: .leading) {
                Text(destination.name)
                    .font(.system(size: 18, weight: .bold))
                Text(destination.country)
                
                HStack {
                    ForEach(0..<5, id: \.self) { num in
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    }
                }.padding(.top, 2)
                
                Text(vm.destinationDetails?.description ?? "")
                    .padding(.top, 4)
                    .font(.system(size: 15))
                
                HStack { Spacer() }
            }.padding(.horizontal)
            
            HStack {
                Text("Location")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button(action: {
                    // this can have control on toggle(switch) also.
                    isShowingAttractions.toggle()
                }, label: {
                    Text("\(isShowingAttractions ? "Hide" : "Show") Attractions")
                       .font(.system(size: 12, weight: .semibold))
                })
                
                // UIKit: UISwitch
                Toggle("", isOn: $isShowingAttractions)
                    .labelsHidden()
                
            }.padding(.horizontal)
            
            // we use $ before the region variable because it is a binding variable.
            Map(coordinateRegion: $region, annotationItems: isShowingAttractions ? attractions : []) { attraction in
//                MapMarker(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude), tint: .red)
                
                MapAnnotation(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude)) {
                    CustomMapAnnotation(attraction: attraction)
                }
            }.frame(height: 300)
            
        }.navigationBarTitle(destination.name, displayMode: .inline)
    }
}

struct CustomMapAnnotation: View {
    
    let attraction: Attraction
    
    var body: some View {
        VStack {
            Image(attraction.imageName)
                .resizable()
                .frame(width: 80, height: 60)
                .cornerRadius(4)
                // To create border around the text. We use .overlay instead of .border cuz the .border does not look as perfect as .overlay when we add .cornerRadius.
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.init(white: 0, alpha: 0.3)))
                )
            
            Text(attraction.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(4)
                // To create border around the text. We use .overlay instead of .border cuz the .border does not look as perfect as .overlay when we add .cornerRadius.
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.init(white: 0, alpha: 0.3)))
                )
            
        }.shadow(radius: 5)
    }
}

struct Attraction: Identifiable {
    // id is the var from conforming Identifiable
    let id = UUID().uuidString
    let name, imageName: String
    let latitude, longitude: Double
}

struct PopularDestinationTile: View {
    
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .cornerRadius(4)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
            
            Text(destination.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .foregroundColor(Color(.label))
            
            Text(destination.country)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                .foregroundColor(.gray)
        }
        .asTile()
    }
}

struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularDestinationsView()
        DiscoverView()
    }
}
