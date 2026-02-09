//
//  RideNavigationView.swift
//  Fastgo
//
//  Created by vishwas on 1/24/26.
//

import SwiftUI

struct RideNavigationView: View {
    @EnvironmentObject private var router: HomeRouter
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var rideViewModel: RideNavigationViewModel
    let scooterAnnotation: ScooterAnnotation?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(mapViewModel: mapViewModel, rideViewModel: rideViewModel, isNavigationMode: true)
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                LocationButton(viewModel: mapViewModel)
                RideStateBottomCard(mapViewModel: mapViewModel, rideViewModel: rideViewModel)
            }
            .padding(22)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomToolBarBackButton(action: {
                    rideViewModel.resetRideState()
                    router.navigatePop()
                })
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            if let scooter = scooterAnnotation, rideViewModel.rideStatus == .reserved {
                Task {
                    await rideViewModel.startNavigation(to: scooter, userLocation: mapViewModel.currentUserLocation)
                    mapViewModel.fitCameraToRoute(destination: scooter.coordinates)
                }
            }
        }
        .onChange(of: rideViewModel.didScanQRSuccessfully) { oldValue, newValue in
            if newValue {
                rideViewModel.updateStatus(to: .inProgress, userLocation: mapViewModel.currentUserLocation)
                rideViewModel.resetQRScanStatus()
            }
        }
        .onReceive(mapViewModel.locationManager.$currentLocation) { newLocation in
            guard let location = newLocation else { return }
            
            // Update route ETA during navigation modes
            Task {
                await rideViewModel.updateRouteIfNeeded(userLocation: location)
            }
            
            // Track distance traveled during ride
            rideViewModel.updateRideDistance(newLocation: location)
        }
    }
}

#Preview {
    RideNavigationView(mapViewModel: MapViewModel(), rideViewModel: RideNavigationViewModel(), scooterAnnotation: nil)
        .environmentObject(HomeRouter())
}
