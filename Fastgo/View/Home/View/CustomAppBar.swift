//
//  CustomAppBar.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI

struct CustomAppBar: View {
    @EnvironmentObject private var router : HomeRouter
    @StateObject var mapViewModel : MapViewModel
    var body: some View {
            HStack{
                Button(action:{
                    router.navigate(to: .profile)
                },label: {
                    Image("boy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                })
                Spacer()
                VStack(spacing:8){
                    HStack{
                        Image(systemName: "location.fill")
                            .foregroundStyle(.green)
                        Text("Your location")
                            .font(.callout)
                            .fontWeight(.light)
                            .foregroundStyle(.gray)
                    }
                    Text(mapViewModel.userLocation)
                        .font(.headline)
                        .fontWeight(.light)
                        .lineLimit(1)
                }
                .frame(maxWidth: 200,maxHeight: 60)
                Spacer()
                Button(action:{
                    
                },label: {
                    Image(systemName: "bell")
                        .font(.title)
                        .foregroundStyle(.black)
                        .frame(width: 60, height: 60)
                        .background(.white)
                        .clipShape(Circle())
                        .frame(height: 60)
                })
            }
    }
}


#Preview {
    CustomAppBar(mapViewModel: MapViewModel())
}
