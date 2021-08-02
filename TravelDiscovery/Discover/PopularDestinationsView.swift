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
                            destination: PopularDestinationDetailsView(destination: destination),
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

struct PopularDestinationDetailsView: View {
    
    let destination: Destination
    
    // we put @State before the region variable because it is a binding variable, which means every time we move the map, this variable keeps changing.
    @State var region: MKCoordinateRegion
    @State var isShowingAttractions = false
    
    let attractions: [Attraction] = [
        .init(name: "Eiffel Tower", latitude: 48.858605, longitude: 2.2946),
        .init(name: "Champs-Elysees", latitude: 48.866867, longitude: 2.311780),
        .init(name: "Louvre Museum", latitude: 48.860288, longitude: 2.337789)
    ]
    
    init(destination: Destination) {
        self.destination = destination
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }
    
    var body: some View {
        ScrollView {
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
            
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
                
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
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
                MapMarker(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude), tint: .red)
            }.frame(height: 300)
            
        }.navigationBarTitle(destination.name, displayMode: .inline)
    }
}

struct Attraction: Identifiable {
    // id is the var from conforming Identifiable
    let id = UUID().uuidString
    let name: String
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
