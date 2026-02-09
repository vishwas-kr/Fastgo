//
//  QRCodeScanView.swift
//  Fastgo
//
//  Created by vishwas on 1/23/26.
//

import SwiftUI
import AVFoundation

struct QRCodeScanView: View {
    
    @StateObject private var viewModel = QRCodeScanViewModel()
    @EnvironmentObject var router: HomeRouter
    let source: QRScanSource
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var rideViewModel: RideNavigationViewModel
    let rotationDegrees: [Double] = [0, 90, 180, 270]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 55) {
                Spacer()
                
                VStack(spacing: 12) {
                    Text("Scan QR")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    Text("You can find it on the scooter's front panel \n free to unlock and +$0.39/min + tax")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 30)
                
                ZStack {
                    ForEach(0..<4) { index in
                        EdgeRectangleView(inlineErrorMsg: $viewModel.inlineErrorMsg, scannedCode: $viewModel.scannedCode)
                            .rotationEffect(.degrees(rotationDegrees[index]))
                    }
                    .frame(width: 270, height: 270)
                    
                    ScannerView(
                        scannedCode: $viewModel.scannedCode,
                        inlineErrorMsg: $viewModel.inlineErrorMsg,
                        alertErrorMsg: $viewModel.alertErrorMsg,
                        isFlashOn: $viewModel.isFlashOn
                    )
                    .frame(width: 260, height: 260)
                    .cornerRadius(20)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(.white.opacity(0.2))
                    )
                }
                
                if let message = viewModel.inlineErrorMsg {
                    Text(message)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .transition(.opacity)
                }
                
                Button {
                    viewModel.isFlashOn.toggle()
                } label: {
                    Image(systemName: viewModel.isFlashOn ? "flashlight.on.fill" : "flashlight.off.fill")
                        .font(.largeTitle)
                        .frame(width: 48, height: 48)
                        .foregroundStyle(.white)
                        .background(Circle().fill(.gray))
                }
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.resetScannerState()
        }
        .onChange(of: viewModel.scannedCode) { oldValue, newValue in
            guard newValue != nil else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)  {
                switch source {
                case .home:
                    rideViewModel.updateStatus(to: .inProgress, userLocation: mapViewModel.currentUserLocation)
                    mapViewModel.centerUserLocation()
                    router.navigatePop()
                    router.navigate(to: .rideNavigation(nil))
                case .rideNavigation:
                    RideNavigationViewModel.notifyQRScanSuccess()
                    router.navigatePop()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CustomToolBarBackButton(
                    foregroundColor: .white,
                    backgroundColor: .gray.opacity(0.1)
                )
            }
        }
        .alert(
            "Scan Error",
            isPresented: .constant(viewModel.alertErrorMsg != nil)
        ) {
            Button("OK") {
                viewModel.alertErrorMsg = nil
            }
        } message: {
            Text(viewModel.alertErrorMsg ?? "")
        }
    }
}


#Preview {
    QRCodeScanView(source: .home, mapViewModel: MapViewModel(), rideViewModel: RideNavigationViewModel())
        .environmentObject(HomeRouter())
}
