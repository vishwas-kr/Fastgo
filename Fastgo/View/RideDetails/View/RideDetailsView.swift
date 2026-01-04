//
//  RideDetailsView.swift
//  Fastgo
//
//  Created by vishwas on 12/31/25.
//

import SwiftUI

struct RideDetailsView: View {
    @State private var showSheet : Bool = false
    var body: some View {
        VStack{
            ScooterDetail()
            VStack{
                ScooterDetailFeatures()
                
                List {
                    ForEach(ScooterDetailOptions.allCases,id:\.self){index in
                        HStack(spacing:16){
                            Image(index.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width:40,height:40)
                            Text(index.title)
                                .font(.callout)
                        }
                    }
                }
                
                ScooterAction()
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedCorners(radius:32))
            .ignoresSafeArea()
        }.background(.white)
    }
}


#Preview {
    RideDetailsView()
}



