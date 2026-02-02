//
//  RideStateBottomCard.swift
//  Fastgo
//
//  Created by vishwas on 2/1/26.
//

import SwiftUI

struct RideStateBottomCard : View {
    @EnvironmentObject private var router: HomeRouter
    @ObservedObject var mapViewModel : MapViewModel
    @ObservedObject var rideViewModel : RideNavigationViewModel
        
    var body : some View {
        ZStack {
            if mapViewModel.rideStatus == .reserved {
                CustomGreenButton(action: {
                    mapViewModel.updateStatus(to: .cancelled)
                }, title: "Reserve now (free for 10 mins)",imageName: nil)
                .transition(.scale.combined(with: .opacity))
            }
            
            else if mapViewModel.rideStatus == .inProgress {
                InProgressRideCard(viewModel: mapViewModel, onComplete: {
                    router.navigate(to: .rideCompleted)
                })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            else if mapViewModel.rideStatus == .cancelled {
                CancellationRideCard(viewModel: mapViewModel, rideViewModel: rideViewModel)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: mapViewModel.rideStatus)
        
    }
}
