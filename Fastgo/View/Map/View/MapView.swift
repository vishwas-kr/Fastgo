//
//  Map.swift
//  Fastgo
//
//  Created by vishwas on 1/15/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel : MapViewModel
    
    var body: some View {
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()
        }
        .mapStyle(.standard)
        .onAppear {
            viewModel.requestPermission()
        }
    }
}

//#Preview {
//    MapView(viewModel: MapViewModel())
//}
