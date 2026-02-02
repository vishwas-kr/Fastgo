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
                .frame(width: 40, height: 40)
            
            content
        }
        .overlay(alignment: .bottom) {
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundStyle(.white)
                .rotationEffect(.degrees(180))
                .offset(y: 10)
        }
    }
}


struct ScooterAnnotationContent: View {
    let annotation: ScooterAnnotation
    @ObservedObject var mapViewModel : MapViewModel
    
    private var isSelectedForNavigation: Bool {
        mapViewModel.navigatingToScooter?.id == annotation.id
    }
    
    private var showCapsule: Bool {
        isSelectedForNavigation && mapViewModel.routePolyline != nil && mapViewModel.rideStatus == .reserved
    }
    
    var body: some View {
        VStack{
            MapAnnotationContainer {
                VStack(spacing: 0) {
                    Image(annotation.image)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.white)
                    
                    Image("power")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(annotation.powerColor)
                        .rotationEffect(.degrees(90))
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
    ScooterAnnotationContent(annotation: .preview, mapViewModel: MapViewModel())
}
