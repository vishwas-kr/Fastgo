//
//  RideStateBottomCard.swift
//  Fastgo
//
//  Created by vishwas on 2/1/26.
//

import SwiftUI

struct RideStateBottomCard : View {
    @EnvironmentObject private var router: HomeRouter
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var rideViewModel: RideNavigationViewModel
        
    var body : some View {
        ZStack {
            if rideViewModel.rideStatus == .reserved {
                CustomGreenButton(action: {
                    rideViewModel.updateStatus(to: .cancelled, userLocation: mapViewModel.currentUserLocation)
                }, title: "Reserve now (free for 10 mins)", imageName: nil)
                .transition(.scale.combined(with: .opacity))
            }
            
            else if rideViewModel.rideStatus == .inProgress {
                InProgressRideCard(mapViewModel: mapViewModel, rideViewModel: rideViewModel, onComplete: {
                    router.navigate(to: .rideCompleted)
                })
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            else if rideViewModel.rideStatus == .cancelled {
                CancellationRideCard(mapViewModel: mapViewModel, rideViewModel: rideViewModel)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: rideViewModel.rideStatus)
    }
}
