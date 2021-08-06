//
//  RestaurantPhotosView.swift
//  TravelDiscovery
//
//  Created by horkimlong on 6/8/21.
//

import SwiftUI
import Kingfisher

struct RestaurantPhotosView: View {
    
    let photoUrlStrings = [
        "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/e2f3f5d4-5993-4536-9d8d-b505d7986a5c",
        "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/a4d85eff-4c79-4141-a0d6-761cca48eae1",
        "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/20a6783b-3de7-4e58-9e22-bcc6a43b6df6"
    ]
    
    var body: some View {
        
        // GRID
        
        // we use GeometryReader cuz we want to access the screen width
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: [
                    
                    // "proxy.size.width" is the frame of the entire view
                    GridItem(.adaptive(minimum: proxy.size.width / 3 - 4, maximum: 300), spacing: 2)
                ], spacing: 4, content: {
                    ForEach(photoUrlStrings, id: \.self) { urlString in
                        KFImage(URL(string: urlString))
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width / 3 - 3, height: proxy.size.width / 3 - 3)
                            .clipped()
                    }
                }).padding(.horizontal, 3)
                
            }.navigationBarTitle("All Photos", displayMode: .inline)
        }
    }
}

struct RestaurantPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantPhotosView()
    }
}
