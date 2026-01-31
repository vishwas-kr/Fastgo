//
//  InProgressRideCard.swift
//  Fastgo
//
//  Created by vishwas on 2/1/26.
//

import SwiftUI

struct InProgressRideCard : View {
    @ObservedObject var viewModel : MapViewModel
    var body : some View {
        VStack{
            HStack(spacing:18){
                CapsuleComponent(image:"bolt.circle", title: "90%" )
                Divider()
                    .background(.white)
                    .frame(height: 10)
                CapsuleComponent(image:"clock", title: "24 min" )
                Divider()
                    .background(.white)
                    .frame(height: 10)
                CapsuleComponent(image:"arrow.swap", title: "~3 km" )
            }
            .padding(.vertical,12)
            SldeToAction(color: .green, title: "Swipe to finish ride", completedTitle: "Finishing..."){
                viewModel.updateStatus(to: .completed)
            }
        }
        .padding(6)
        .background{
            RoundedRectangle(cornerRadius: 33).fill(.black)
        }
    }
}

