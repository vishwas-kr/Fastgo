//
//  RideHistoryViewModel.swift
//  Fastgo
//
//  Created by vishwas on 1/29/26.
//
import Foundation

@MainActor
class RideHistoryViewModel : ObservableObject {
    
    @Published var selectedTab : Int = 0
    @Published private(set) var rides : [Ride] = []
    @Published var isLoading : Bool = false
    
    private var rideService = RideService.shared
    private var appState = AppStateManager.shared
    
    let tabs : [String] = ["All", "Completed", "Upcoming", "Cancelled"]
    
    func loadRides() async {
        guard let userId = appState.currentUser?.id else {return}
        isLoading = true
        do {
            rides = try await rideService.fetchRides(userId: userId)
            print("Rides: \(rides)")
            isLoading = false
        } catch {
            print("Error Fecthing Rides: \(error)")
            isLoading = false
        }
    }
    
    var filterRides : [Ride] {
        switch selectedTab {
        case 1: return rides.filter{$0.status == .completed}
        case 2: return rides.filter{$0.status == .upcoming}
        case 3: return rides.filter{$0.status == .cancelled}
        default : return rides
        }
    }
    
    var uiModels : [RideStatusModel] {
        filterRides.map{
            RideStatusModel(location: $0.startLocationName, date: Date.rideDateFormatter($0.rideDate), fare: $0.fareAmount, status: $0.status)
        }
    }

}
