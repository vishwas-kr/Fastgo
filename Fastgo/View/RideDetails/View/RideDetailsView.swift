//
//  RideDetailsView.swift
//  Fastgo
//
//  Created by vishwas on 12/31/25.
//

import SwiftUI

struct RideDetailsView: View {
    let annotation: RideAnnotation
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
     RideDetailsView(annotation:  RideAnnotation(title: "Uru Cruiser", vehicleDetails: .init(type: .seated, battery: 75, range: 22, perMinCost: 0.39, imageName: "scooter", coordinates: .init(latitude: 37.333923550821474, longitude: -122.01485265580054))), mapViewModel: MapViewModel())
 }
