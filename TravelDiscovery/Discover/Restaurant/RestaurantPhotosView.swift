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
    
    @State var mode = "grid"
    
    init() {
        // This changes every UIsegmentedControl in your applicaiton1
        UISegmentedControl.appearance().backgroundColor = .black
        UISegmentedControl.appearance().selectedSegmentTintColor = .orange
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
    }
    
    @State var shouldShowFullscreenModal = false
    @State var selectedPhotoIndex = 0
    
    var body: some View {
        
        // GRID
        
        // we use GeometryReader cuz we want to access the screen width
        GeometryReader { proxy in
            ScrollView {
                
                Picker("Test", selection: $mode) {
                    Text("Grid").tag("grid")
                    Text("List").tag("list")
                }.pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldShowFullscreenModal, content: {
                        ZStack(alignment: .topLeading) {
                            Color.black.ignoresSafeArea()
                            RestaurantCarouselView(imageUrlStrings: photoUrlStrings, selectedIndex: selectedPhotoIndex)

/* WE also can use TabView instead of using the RestaurantCarouselView, which is a custom paging view controller class.
                            TabView(selection: $selectedPhotoIndex) {
                                ForEach(photoUrlStrings, id: \.self, content: { urlString in
                                    KFImage(URL(string: urlString))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width, height: 400)
                                        .clipped()
                                        .tag(photoUrlStrings.firstIndex(of: urlString) ?? 0)
                                })
                            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            
 */
                            Button {
                                shouldShowFullscreenModal.toggle()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }).opacity(shouldShowFullscreenModal ? 1 : 0)
                
                if mode == "grid" {
                    LazyVGrid(columns: [
                        
                        // "proxy.size.width" is the frame of the entire view
                        GridItem(.adaptive(minimum: proxy.size.width / 3 - 4, maximum: 300), spacing: 2)
                    ], spacing: 4, content: {
                        
                        ForEach(photoUrlStrings, id: \.self) { urlString in
                            
                            Button(action:{
                                selectedPhotoIndex = photoUrlStrings.firstIndex(of: urlString) ?? 0
                                shouldShowFullscreenModal.toggle()
                            }, label: {
                                KFImage(URL(string: urlString))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: proxy.size.width / 3 - 3, height: proxy.size.width / 3 - 3)
                                    .clipped()
                            })
                        }
                    }).padding(.horizontal, 3)
                } else {
                    ForEach(photoUrlStrings, id: \.self) { urlString in
                        VStack(alignment: .leading, spacing: 8) {
                            KFImage(URL(string: urlString))
                                .resizable()
                                .scaledToFill()
                            
                            HStack {
                                Image(systemName: "heart")
                                Image(systemName: "bubble.right")
                                Image(systemName: "paperplane")
                                Spacer()
                                Image(systemName: "bookmark")
                            }.padding(.horizontal, 8)
                            .font(.system(size: 22))
                            
                            Text("Description for your post and it goes here, make sure to use a bunch of lines of text otherwise you never know what's going to happend")
                                .font(.system(size: 14))
                                .padding(.horizontal, 8)
                            
                            Text("Posted on 10/01/20")
                                .font(.system(size: 14))
                                .padding(.horizontal, 8)
                                .foregroundColor(.gray)
                            
                        }.padding(.bottom)
                    }
                }
                
            }.navigationBarTitle("All Photos", displayMode: .inline)
        }
    }
}

struct RestaurantPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantPhotosView()
    }
}
