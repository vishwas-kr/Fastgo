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
    let scooterAnnotation: ScooterAnnotation?
    @StateObject private var rideViewModel = RideNavigationViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(mapViewModel: mapViewModel, isNavigationMode: true)
                .ignoresSafeArea(.all)
            
            VStack {
//                AnnotationInfoCapsule(
//                    timeData: mapViewModel.formattedDuration,
//                    distanceData: mapViewModel.formattedDistance,
//                    isVisible: mapViewModel.routePolyline != nil && mapViewModel.rideStatus == .reserved
//                )
//                .animation(.spring(), value: mapViewModel.routePolyline != nil)
                
                Spacer()
                
                LocationButton(viewModel: mapViewModel)
                RideStateBottomCard(mapViewModel: mapViewModel,rideViewModel: rideViewModel)
            }
            .padding(22)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomToolBarBackButton(action: {
                    mapViewModel.resetRideState()
                    router.navigatePop()
                })
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            if let scooter = scooterAnnotation {
                mapViewModel.startNavigation(to: scooter)
            }
        }
        .onChange(of: rideViewModel.didScanQRSuccessfully) { oldValue, newValue in
            if newValue {
                mapViewModel.updateStatus(to: .inProgress)
                rideViewModel.resetQRScanStatus()
            }
        }
    }
}

#Preview {
    RideNavigationView(mapViewModel: MapViewModel(), scooterAnnotation: nil)
        .environmentObject(HomeRouter())
}
