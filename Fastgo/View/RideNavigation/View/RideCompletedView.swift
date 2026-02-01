//
//  RideCompletedView.swift
//  Fastgo
//
//  Created by vishwas on 2/1/26.
//

import SwiftUI

struct RideCompletedView: View {
    @EnvironmentObject private var router: HomeRouter
    @ObservedObject var mapViewModel: MapViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 150, height: 150)
                
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.green)
                    .frame(width: 80, height: 80)
            }
            
            VStack(spacing: 8) {
                Text("Ride Completed!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Thanks for riding with Fastgo")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 16) {
                HStack(spacing: 24) {
                    RideStatItem(icon: "clock", title: "Duration", value: mapViewModel.formattedDuration)
                    
                    Divider()
                        .frame(height: 40)
                    
                    RideStatItem(icon: "arrow.swap", title: "Distance", value: mapViewModel.formattedDistance)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal)
            
            Spacer()
            
            CustomGreenButton(action: {
                mapViewModel.resetRideState()
                router.navigateToHome()
            }, title: "Done",imageName: nil)
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RideStatItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.green)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    RideCompletedView(mapViewModel: MapViewModel())
        .environmentObject(HomeRouter())
}
