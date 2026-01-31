//
//  ScooterAction.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//

import SwiftUI
struct ScooterRideActionFeatures: View {
    @EnvironmentObject private var router : HomeRouter
    let viewModel : MapViewModel
    var body: some View {
        HStack{
            ForEach(ScooterRideActions.allCases,id:\.self){index in
                Button(action: {
                    if index.rawValue == "Navigate" {
//                        Task{
//                            await viewModel.drawRoute(to:viewModel.selectedAnnotation!.coordinates)
//                            viewModel.selectedAnnotation = nil
//                        }
                        viewModel.selectedAnnotation = nil
                        router.navigate(to: .rideNavigation)
                       
                    }
                }, label: {
                    HStack{
                        Image(systemName: index.image)
                        Text(index.rawValue)
                            .font(.callout)
                    }
                    .padding(10)
                    
                })
                .foregroundStyle(.black)
                    .background(.white)
                    .clipShape(Capsule())
                
            }
        }
        .padding(.top)
    }
}
