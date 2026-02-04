//
//  CancellationRideCard.swift
//  Fastgo
//
//  Created by vishwas on 2/1/26.
//

import SwiftUI

struct CancellationRideCard : View {
    @ObservedObject var mapViewModel: MapViewModel
    @EnvironmentObject private var router: HomeRouter
    @ObservedObject var rideViewModel: RideNavigationViewModel
    
    var body : some View {
        VStack(spacing: 18) {
            VStack(spacing: 12) {
                Text("Reservation time left")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Text(rideViewModel.formattedTime)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                SldeToAction(
                    color: Color(.cardCancel),
                    title: rideViewModel.isTimerExpired ? "Ride can't be cancelled" : "Swipe to cancel",
                    completedTitle: "Cancelling"
                ) {
                    rideViewModel.updateStatus(to: .reserved, userLocation: mapViewModel.currentUserLocation)
                }
                .disabled(rideViewModel.isTimerExpired)
                .opacity(rideViewModel.isTimerExpired ? 0.5 : 1.0)
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 33).fill(.cardCancel)
            }
            CustomGreenButton(action: {
                router.navigate(to: .scanQRCode(.rideNavigation))
            }, title: "Scan QR", imageName: "qrcode.viewfinder")
        }
        .onAppear {
            rideViewModel.startTimer()
        }
        .onDisappear {
            rideViewModel.stopTimer()
        }
    }
}


#Preview {
    CancellationRideCard(mapViewModel: MapViewModel(), rideViewModel: RideNavigationViewModel())
}
