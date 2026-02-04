//
//  Map.swift
//  Fastgo
//
//  Created by vishwas on 1/15/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var rideViewModel: RideNavigationViewModel
    var isNavigationMode: Bool = false
    
    var body: some View {
        Map(position: $mapViewModel.cameraPosition) {
            if isNavigationMode {
                if let userCoord = mapViewModel.currentUserCoordinate {
                    Annotation("", coordinate: userCoord) {
                        UserLocationAnnotation(isRiding: rideViewModel.rideStatus == .inProgress)
                    }
                }
            } else {
                UserAnnotation()
            }
            
            if rideViewModel.rideStatus == .inProgress {
                ForEach(rideViewModel.parkingAnnotations) { parking in
                    Annotation("", coordinate: parking.coordinates) {
                        Button(action: {
                            Task {
                                await rideViewModel.selectParkingAnnotation(parking, userLocation: mapViewModel.currentUserLocation)
                            }
                        }) {
                            ParkingAnnotationView(
                                annotation: parking,
                                rideViewModel: rideViewModel
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else {
                ForEach(rideViewModel.scooterAnnotations) { annotation in
                    Annotation("", coordinate: annotation.coordinates) {
                        Button(action: {
                            if !isNavigationMode {
                                mapViewModel.selectAnnotation(annotation: annotation)
                            }
                        }) {
                            ScooterAnnotationContent(
                                annotation: annotation,
                                rideViewModel: rideViewModel
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            if let polyline = rideViewModel.routePolyline {
                MapPolyline(polyline)
                    .stroke(Color.green, lineWidth: 4)
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .onAppear {
            mapViewModel.requestPermission()
        }
        .task {
            await rideViewModel.fetchNearByScooters()
        }
    }
}

//#Preview {
//    MapView(mapViewModel: MapViewModel(), rideViewModel: RideNavigationViewModel())
//}

