//
//  ParkingAnnotationView.swift
//  Fastgo
//
//  Created by vishwas on 2/1/26.
//

import SwiftUI

struct ParkingAnnotationView: View {
    let annotation: ParkingAnnotation
    @ObservedObject var mapViewModel: MapViewModel
    
    private var isSelectedForNavigation: Bool {
        mapViewModel.selectedParkingAnnotation?.id == annotation.id
    }
    
    private var showCapsule: Bool {
        isSelectedForNavigation && mapViewModel.routePolyline != nil && mapViewModel.rideStatus == .inProgress
    }
    
    var body: some View {
        VStack {
            MapAnnotationContainer {
                Circle()
                    .fill(.white)
                    .stroke(.white, lineWidth: 4)
                    .frame(width: 45, height: 45)
                    .overlay {
                        VStack(spacing: 0) {
                            Image(systemName: "p.circle.fill")
                                .font(.system(size: 34))
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .foregroundStyle(.blue)
                        }
                    }
            }
            AnnotationInfoCapsule(
                timeData: mapViewModel.formattedDuration,
                distanceData: mapViewModel.formattedDistance,
                isVisible: showCapsule
            )
            .padding(.top, 6)
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        ParkingAnnotationView(
            annotation: ParkingAnnotation(
                id: "preview",
                coordinate: .init(latitude: 0, longitude: 0),
                name: "Test Parking",
                spotsAvailable: 5
            ),
            mapViewModel: MapViewModel()
        )
    }
}
