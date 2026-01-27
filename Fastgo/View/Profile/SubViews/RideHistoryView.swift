//
//  RideHistoryView.swift
//  Fastgo
//
//  Created by vishwas on 1/11/26.
//

import SwiftUI

struct RideHistoryView: View {
    @State var selectedTab : Int = 0
    @Namespace private var underlineNamespace
    let tabs : [String] = ["All", "Completed", "Upcoming", "Canceled"]
    let rides : [RideStatusModel] = [
        RideStatusModel(location: "Westheimer Rd. Santa Cruse Bay", date: "Today, 12:38 PM", fare: -12.12,status : .upcoming),
        RideStatusModel(location: "1901 Thornridge Circit road", date: "Yesterday, 10:45 AM", fare: -15.00, status : .completed)
    ]
    
    var filterRides : [RideStatusModel] {
        switch selectedTab {
            case 0:
                return rides
            case 1:
                return rides.filter { $0.status == .completed }
            case 2:
                return rides.filter { $0.status == .upcoming }
            case 3:
                return rides.filter { $0.status == .cancelled }
            default:
                return rides
            }
    }
    var body: some View {
        GeometryReader { geo in
            ZStack{
                VStack {
                    Image(AssetImage.Profile.rideHistoryBackground)
                        .resizable()
                        .scaledToFill()
                        .frame(height: geo.size.height * 0.3)
                        .ignoresSafeArea(edges: .top)
                    Spacer()
                }
                VStack(alignment: .leading){
                    VStack(alignment: .leading, spacing: 18){
                        Text("Ride History")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        
                        Text("Here you'll find the list of all the rides you have valideted, and theri fares.")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundStyle(.black)
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom,22)
                    
                    tabsView
                    
                    
                    VStack {
                        ForEach(filterRides){ride in
                            RideRowView(ride: ride)
                        }
                    }.padding()
                    
                    Spacer()
                    
                }
                .padding(.top,30)
                .background(Color(.systemGray6))
                .clipShape(RoundedCorners(radius: 32, corners: [.topLeft, .topRight]))
                .offset(y: geo.size.height * 0.18)
                
            }
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    CustomToolBarBackButton()
                }
            }
        }
    }
    
    private var tabsView : some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack (spacing:0) {
                ForEach(tabs.indices, id:\.self) {index in
                    
                    VStack{
                        Text(tabs[index])
                            .fontWeight(selectedTab == index ? .bold : .regular)
                            .padding(.horizontal,22)
                            .onTapGesture {
                                selectedTab = index
                            }
                        if selectedTab == index {
                            Rectangle()
                                .frame(height:2)
                                .foregroundStyle(.green)
                                .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                        } else {
                            Rectangle()
                                .frame(height:0.5)
                                .foregroundStyle(Color(.systemGray3))
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    RideHistoryView()
}

