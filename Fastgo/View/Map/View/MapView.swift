//
//  Map.swift
//  Fastgo
//
//  Created by vishwas on 1/15/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var mapViewModel : MapViewModel
    var isNavigationMode: Bool = false
    
    var body: some View {
        Map(position: $mapViewModel.cameraPosition) {
            if isNavigationMode {
                if let userCoord = mapViewModel.currentUserCoordinate {
                    Annotation("", coordinate: userCoord) {
                        UserLocationAnnotation(isRiding: mapViewModel.rideStatus == .inProgress)
                    }
                }
            } else {
                UserAnnotation()
            }
            
            if mapViewModel.rideStatus == .inProgress {
                ForEach(mapViewModel.parkingAnnotations) { parking in
                    Annotation("", coordinate: parking.coordinates) {
                        Button(action: { mapViewModel.selectParkingAnnotation(parking) }) {
                            ParkingAnnotationView()
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else {
                ForEach(mapViewModel.annotations) { annotation in
                    Annotation("", coordinate: annotation.coordinates) {
                        Button(action: {
                            if !isNavigationMode {
                                mapViewModel.selectAnnotation(annotation: annotation)
                            }
                        }) {
                            ScooterAnnotationContent(
                                image: annotation.image,
                                powerColor: annotation.powerColor,
                                mapViewModel: mapViewModel
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(isNavigationMode)
                    }
                }
            }
            
            if let polyline = mapViewModel.routePolyline {
                MapPolyline(polyline)
                    .stroke(Color.green, lineWidth: 4)
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .onAppear {
            mapViewModel.requestPermission()
        }
        .task {
            await mapViewModel.getNearByScooters()
        }
    }
}

//#Preview {
//    MapView(mapViewModel: MapViewModel())
//}

