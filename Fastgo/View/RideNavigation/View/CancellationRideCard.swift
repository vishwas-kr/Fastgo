//
//  CancellationRideCard.swift
//  Fastgo
//
//  Created by vishwas on 2/1/26.
//

import SwiftUI

struct CancellationRideCard : View {
    @ObservedObject var viewModel : MapViewModel
    var body : some View {
        VStack{
            Text("Reservation time left")
                .font(.subheadline)
                .foregroundStyle(.white)
            Text("06 : 23 mins")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            SldeToAction(color: Color(.cardCancel), title: "Swipe to cancel", completedTitle: "Cancelling"){viewModel.updateStatus(to: .reserved)}
        }
        .padding(6)
        .background{
            RoundedRectangle(cornerRadius: 33).fill(.cardCancel)
        }
        
    }
}

