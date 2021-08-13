//
//  TrendingCreatorsView.swift
//  TravelDiscovery
//
//  Created by horkimlong on 27/7/21.
//

import SwiftUI

struct TrendingCreatorsView: View {
    let users: [User] = [
        .init(name: "Amy Adams", imageName: "amy", id: 0),
        .init(name: "Billy", imageName: "billy", id: 1),
        .init(name: "Sam Smith", imageName: "sam", id: 2)
    ]
    
    var body: some View {
        VStack{
            HStack {
                Text("Popular places to eat")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(users, id: \.self) { user in
                        NavigationLink(
                            destination: UserDetailsView(user: user),
                            label: {
                                DiscoverUserView(user: user)
                        })
                    }
                }.padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

struct DiscoverUserView: View {
    let user: User
    var body: some View {
        VStack {
            Image(user.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(60)
            Text(user.name)
                .font(.system(size: 11, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.label))
        }
            .frame(width: 60)
            .shadow(color: .gray, radius: 4, x: 0.0, y: 2)
    }
}

struct TrendingCreatorsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingCreatorsView()
    }
}
