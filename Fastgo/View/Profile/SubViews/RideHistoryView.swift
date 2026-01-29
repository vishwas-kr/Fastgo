//
//  RideHistoryView.swift
//  Fastgo
//
//  Created by vishwas on 1/11/26.
//

import SwiftUI

struct RideHistoryView: View {
    @StateObject private var viewModel = RideHistoryViewModel()
    
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
                    
                    header
                    
                    RideHistoryTabView(viewModel: viewModel)
                    
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.2)
                                    .padding(.top, 40)
                            } else if viewModel.uiModels.isEmpty {
                                Text("No rides found")
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            } else {
                                ForEach(viewModel.uiModels) { ride in
                                    RideRowView(ride: ride)
                                }
                            }
                        }.padding(.bottom,55)
                        .padding()
                    }
                    
                    
                    Spacer()
                    
                }
                .padding(.top,30)
                .background(Color(.systemGray6))
                .clipShape(RoundedCorners(radius: 32, corners: [.topLeft, .topRight]))
                .offset(y: geo.size.height * 0.18)
                
            }
            .task {
                await viewModel.loadRides()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    CustomToolBarBackButton()
                }
            }
            .onChange(of: viewModel.selectedTab) {
                withAnimation(.easeInOut) {}
            }
        }
    }
    
    private var header : some View {
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
    }
}

#Preview {
    RideHistoryView()
}
