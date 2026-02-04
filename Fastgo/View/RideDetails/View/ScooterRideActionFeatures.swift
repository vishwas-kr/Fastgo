//
//  ScooterAction.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI

struct ScooterRideActionFeatures: View {
    @EnvironmentObject private var router: HomeRouter
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var rideViewModel: RideNavigationViewModel
    
    var body: some View {
        HStack {
            ForEach(ScooterRideActions.allCases, id: \.self) { index in
                Button(action: {
                    if index.rawValue == "Navigate" {
                        let selectedScooter = mapViewModel.selectedAnnotation
                        mapViewModel.selectedAnnotation = nil
                        router.navigate(to: .rideNavigation(selectedScooter))
                    }
                }, label: {
                    HStack {
                        Image(systemName: index.image)
                        Text(index.rawValue)
                            .font(.callout)
                    }
                    .padding(10)
                })
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(Capsule())
            }
        }
        .padding(.top)
    }
}
