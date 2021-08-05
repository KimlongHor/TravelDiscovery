//
//  Destination.swift
//  TravelDiscovery
//
//  Created by horkimlong on 27/7/21.
//

import Foundation

struct Destination: Decodable, Hashable {
    let name, country, imageName: String
//    let description: String
//    let thumbnail: String
//    let photos: [String]
    let latitude, longitude: Double
}
