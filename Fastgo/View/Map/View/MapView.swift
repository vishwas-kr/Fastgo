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
                    Button {
                        Task {
                            await mapViewModel.selectAnnotation(annotation: annotation)
                        }
                    } label: {
                        CustomAnnotation(
                            image: annotation.type.image,
                            powerColor: annotation.type.powerColor
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
    }
}

//#Preview {
//    MapView(viewModel: MapViewModel())
//}

struct CustomAnnotation: View {
    let image : String
    let powerColor : Color
    var body: some View {
        Circle()
            .fill(.black)
            .stroke(.white, lineWidth:4)
            .frame(width:45,height:45)
            .overlay{
                VStack(spacing: 0){
                    Image(image)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width:18,height:18)
                    
                    Image("power")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(powerColor)
                        .frame(width:8,height:8)
                        .rotationEffect(Angle(degrees:90))
                }
                .overlay{
                    Image(systemName:"triangle.fill")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width:10,height:10)
                        .rotationEffect(Angle(degrees:180))
                        .offset(y:27)
                }
            }
    }
}
