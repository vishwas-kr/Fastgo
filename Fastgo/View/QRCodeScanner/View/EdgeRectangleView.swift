//
//  EdgeRectangleView.swift
//  Fastgo
//
//  Created by vishwas on 1/24/26.
//

import SwiftUI

struct EdgeRectangleView: View {
    
    @Binding var inlineErrorMsg: String?
    @Binding var scannedCode : String?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 32)
            .trim(from: 0.3, to: 0.44)
            .stroke(
                qrStateColor(),
                style: StrokeStyle(lineWidth: 5, lineCap: .round)
            )
    }
    
    private func qrStateColor() -> Color {
        if let _ = inlineErrorMsg {
            return .red
        } else if let _ = scannedCode {
            return .green
        } else {
            return .white
        }
    }
}


