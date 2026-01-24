//
//  QRCodeSanViewModel.swift
//  Fastgo
//
//  Created by vishwas on 1/23/26.
//

import AVFoundation
import SwiftUI

@MainActor
final class QRCodeScanViewModel: ObservableObject {
    
    @Published var scannedCode: String? 
    @Published var inlineErrorMsg: String?
    @Published var alertErrorMsg: String?
    @Published var isFlashOn: Bool = false
    
    @EnvironmentObject var router: HomeRouter
    
    func resetScannerState() {
        scannedCode = nil
        inlineErrorMsg = nil
        alertErrorMsg = nil
        isFlashOn = false
    }
}
