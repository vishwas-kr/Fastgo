//
//  RideNavigationView.swift
//  Fastgo
//
//  Created by vishwas on 1/24/26.
//

import SwiftUI

struct RideNavigationView: View {
    @ObservedObject var mapViewModel : MapViewModel
    var body: some View {
        ZStack(alignment: .bottom){
            MapView(mapViewModel: mapViewModel)
                .ignoresSafeArea(.all)
            VStack{
                LocationButton(viewModel: mapViewModel)
                RideStateBottomCard(mapViewModel: mapViewModel)
            }
            .padding(22)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                CustomToolBarBackButton()
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    RideNavigationView(mapViewModel: MapViewModel())
}
