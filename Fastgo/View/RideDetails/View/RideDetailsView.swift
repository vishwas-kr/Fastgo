//
//  RideDetailsView.swift
//  Fastgo
//
//  Created by vishwas on 12/31/25.
//

import SwiftUI

struct RideDetailsView: View {
    let annotation: ScooterAnnotation
    @StateObject var mapViewModel: MapViewModel
    
    var body: some View {
        VStack{
            ScooterDetail(annotation: annotation)
            VStack(spacing:22){
                ScooterRideActionFeatures(viewModel: mapViewModel)
                
                ScooterDetailsOptionsMenu()
                
                ScooterAction()
            }
            .padding()
            .background( Color(.systemGray6).ignoresSafeArea(edges: .bottom))
            .clipShape(RoundedCorners(radius:32))
            
        }.background(.white)
    }
}


 #Preview {
    let scooter = Scooter(
        id: "preview_scooter",
        uniqueCode: "Uru Cruiser",
        type: .offroad,
        battery: 75,
        rangeKm: 22,
        perMinCost: 0.39,
        coordinate: .init(latitude: 37.333923550821474, longitude: -122.007465),
        status: .available
    )
    let annotation = ScooterAnnotation(id: scooter.id, coordinate: scooter.coordinate, scooter: scooter)
     
     RideDetailsView(annotation: annotation, mapViewModel: MapViewModel())
 }
