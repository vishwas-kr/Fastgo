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
    let cordinate = CLLocationCoordinate2D(latitude: 37.330891, longitude: -122.007465)
    let cordinate1 = CLLocationCoordinate2D(latitude: 12.906070487006321, longitude: 77.60124826674085)
    var body: some View {
        Map(position: $mapViewModel.cameraPosition) {
            UserAnnotation()
            ForEach(mapViewModel.annotations){annotation in
                Annotation("", coordinate: annotation.coordinates ){
                    Button(action: { mapViewModel.selectAnnotation(annotation: annotation) }) {
                        CustomAnnotation(
                            image: annotation.image,
                            powerColor: annotation.powerColor
                        )
                    }
                    .buttonStyle(.plain)
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
        .task{
           await mapViewModel.getNearByScooters()
        }
    }
}

//#Preview {
//    MapView(mapViewModel: MapViewModel())
//}

