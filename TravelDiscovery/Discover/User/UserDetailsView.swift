//
//  UserDetailsView.swift
//  TravelDiscovery
//
//  Created by horkimlong on 10/8/21.
//

import SwiftUI
import Kingfisher

struct UserDetails: Hashable, Decodable {
    let username: String
    let firstName: String
    let lastName: String
    let profileImage: String
    let followers: Int
    let following: Int
    let posts: [Post]
}

struct Post: Hashable, Decodable {
    let title: String
    let imageUrl: String
    let views: String
    let hashtags: [String]
}

class UserDetailsViewModel: ObservableObject {
    
    @Published var userDetails: UserDetails?
    init(userId: Int) {
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/user?id=\(userId)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch API -- UserDetailsViewModel", error)
                return
            }
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    self.userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                } catch let jsonError{
                    print("Decoding failed for UserDetails", jsonError)
                }
            }
            
        }.resume()
    }
}

struct UserDetailsView: View {

    @ObservedObject var vm: UserDetailsViewModel
    let user: User
    
    init(user: User) {
        self.user = user
        self.vm = .init(userId: user.id)
    }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(user.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .padding(.top)
                
                Text(user.name)
                    .font(.system(size: 14, weight: .semibold))
                
                HStack {
                    Text("@\(self.vm.userDetails?.username ?? "") •")
                    Image(systemName: "hand.thumbsup.fill")
                    Text("2541")
                }
                .font(.system(size: 14, weight: .regular))
                
                Text("Youtuber, Vlogger, Travel Creator")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(.lightGray))
                
                HStack(spacing: 12) {
                    VStack {
                        Text("59394")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Followers")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(Color(.gray))
                    }
                    
                    Spacer()
                        .frame(width: 0.5, height: 14)
                        .background(Color(.lightGray))
                    
                    VStack {
                        Text("2112")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Following")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundColor(Color(.gray))
                    }
                }
                
                HStack(spacing: 12) {
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Follow")
                                .foregroundColor(.white)
                            Spacer()
                        }.padding(.vertical, 8)
                        .background(Color(.orange))
                        .cornerRadius(100)
                        
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Contact")
                                .foregroundColor(.black)
                            Spacer()
                        }.padding(.vertical, 8)
                        .background(Color(white: 0.9))
                        .cornerRadius(100)
                        
                    })
                }
                .font(.system(size: 12, weight: .semibold))
                
                ForEach(vm.userDetails?.posts ?? [], id: \.self, content: { post in
                    VStack(alignment: .leading) {
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                        
                        HStack {
                            Image(user.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 34)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text(post.views)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                            
                                
                            }
                        }
                        .padding(.horizontal, 8)
                        
                        HStack {
                            ForEach(post.hashtags, id: \.self, content: { hashtag in
                                Text("#\(hashtag)")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(#colorLiteral(red: 0.8051743507, green: 0.8847516775, blue: 0.9846566319, alpha: 1)))
                                    .cornerRadius(20)
                            })
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom)
                    }
                    .background(Color(white: 1))
                    .cornerRadius(12)
                    .shadow(color: .init(white: 0.8), radius: 5, x: 0, y: 4)
                })
                
            }.padding(.horizontal)
            
        }.navigationBarTitle(user.name, displayMode: .inline)
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView(user: .init(name: "Amy Adams", imageName: "amy", id: 0))
    }
}

