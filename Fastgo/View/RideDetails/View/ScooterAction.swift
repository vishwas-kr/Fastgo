//
//  ScooterAction.swift
//  Fastgo
//
//  Created by vishwas on 1/1/26.
//
import SwiftUI

struct ScooterAction: View {
    var body: some View {
        HStack(spacing:16){
            Button(action:{}){
                HStack(spacing: 8) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.title3)
                    
                        .foregroundColor(.white)
                    Text("Scan QR")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 65)
                .background(Color.green)
                .clipShape(Capsule())
            }
            
            Button(action:{}){
                HStack(spacing: 8) {
                    Image(systemName: "bookmark")
                        .font(.title3)
                    
                    
                    Text("Reserve")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height:65)
                .foregroundStyle(.green)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.green)
                )
            }
        }
        .padding()
        .padding(.bottom,30)
    }
}
