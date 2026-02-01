//
//  CustomAnnotation.swift
//  Fastgo
//
//  Created by vishwas on 1/31/26.
//

import SwiftUI

struct MapAnnotationContainer<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.black)
                .stroke(.white, lineWidth: 4)
                .frame(width: 45, height: 45)
            
            content
        }
        .overlay(alignment: .bottom) {
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundStyle(.white)
                .rotationEffect(.degrees(180))
                .offset(y: 6)
        }
    }
}


struct ScooterAnnotationContent: View {
    let image: String
    let powerColor: Color
    @ObservedObject var mapViewModel : MapViewModel
    
    var body: some View {
        VStack{
            MapAnnotationContainer {
                VStack(spacing: 2) {
                    Image(image)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.white)
                    
                    Image("power")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(powerColor)
                        .rotationEffect(.degrees(90))
                }
            }
            AnnotationInfoCapsule(
                timeData: mapViewModel.formattedDuration,
                distanceData: mapViewModel.formattedDistance,
                isVisible: mapViewModel.routePolyline != nil && mapViewModel.rideStatus == .reserved
            )
            .padding(.top, 6)
            .animation(.spring(), value: mapViewModel.routePolyline != nil)
            
        }
    }
}

#Preview {
    ScooterAnnotationContent(image: AssetImage.Map.scooterMarker, powerColor: .red , mapViewModel: MapViewModel())
}
