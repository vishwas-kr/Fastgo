//
//  RideNavigationViewModel.swift
//  Fastgo
//
//  Created by vishwas on 2/2/26.
//
import SwiftUI
import Combine
import MapKit
import CoreLocation

extension Notification.Name {
    static let qrScanSuccessful = Notification.Name("qrScanSuccessful")
}

@MainActor
class RideNavigationViewModel : ObservableObject {
    
    // MARK: - Timer Properties
    @Published var remainingSeconds: Int = 600
    @Published var timer: Timer?
    @Published var didScanQRSuccessfully: Bool = false
    
    // MARK: - Navigation Properties
    @Published var scooterAnnotations: [ScooterAnnotation] = []
    @Published var parkingAnnotations: [ParkingAnnotation] = []
    @Published var routePolyline: MKRoute?
    @Published var rideStatus: RideStatus = .reserved
    @Published var mapMode: MapMode = .browse
    @Published var navigatingToScooter: ScooterAnnotation?
    @Published var selectedParkingAnnotation: ParkingAnnotation?
    @Published var isNavigationMode: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let navigationServices = NavigationServices.shared
    
    init() {
        observeQRScanNotification()
    }
    
    // MARK: - Timer Methods
    var isTimerExpired: Bool {
        remainingSeconds <= 0
    }
    
    var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d : %02d mins", minutes, seconds)
    }
    
    func startTimer() {
        stopTimer()
        remainingSeconds = 600
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                } else {
                    self.stopTimer()
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        stopTimer()
        remainingSeconds = 600
    }
    
    // MARK: - QR Scan Methods
    private func observeQRScanNotification() {
        NotificationCenter.default.publisher(for: .qrScanSuccessful)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.didScanQRSuccessfully = true
            }
            .store(in: &cancellables)
    }
    
    func resetQRScanStatus() {
        didScanQRSuccessfully = false
    }
    
    static func notifyQRScanSuccess() {
        NotificationCenter.default.post(name: .qrScanSuccessful, object: nil)
    }
    
    // MARK: - Data Fetching
    func fetchNearByScooters() async {
        do {
            let scooterDTOs = try await navigationServices.fetchScooters()
            scooterAnnotations = scooterDTOs.map { dto in
                let scooter = Scooter(from: dto)
                return ScooterAnnotation(id: scooter.id, coordinate: scooter.coordinate, scooter: scooter)
            }
        } catch {
            print("Error fetching Scooters: \(error)")
        }
    }
    
    func fetchNearByParking(userLocation: CLLocation?) async {
        guard let userLoc = userLocation else { return }
        
        do {
            let parkingList = try await navigationServices.fetchParking()
            parkingAnnotations = parkingList.map { parking in
                ParkingAnnotation(
                    id: parking.id,
                    coordinate: CLLocationCoordinate2D(latitude: parking.latitude, longitude: parking.longitude),
                    name: parking.name
                )
            }
        } catch {
            print("Error fetching Parking: \(error)")
        }
    }
    
    // MARK: - Route Drawing
    func drawRoute(from userLocation: CLLocation?, to destination: CLLocationCoordinate2D) async {
        guard let userLocation = userLocation else {
            print("Cannot find current location to build route")
            return
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        do {
            let directions = try await MKDirections(request: request).calculate()
            routePolyline = directions.routes.first
        } catch {
            print("Error Drawing Polyline: \(error)")
        }
    }
    
    // MARK: - Navigation Flow
    func startNavigation(to scooter: ScooterAnnotation, userLocation: CLLocation?) async {
        navigatingToScooter = scooter
        isNavigationMode = true
        mapMode = .navigateToScooter
        
        await drawRoute(from: userLocation, to: scooter.coordinates)
    }
    
    func selectParkingAnnotation(_ parking: ParkingAnnotation, userLocation: CLLocation?) async {
        selectedParkingAnnotation = parking
        mapMode = .navigateToParking
        
        await drawRoute(from: userLocation, to: parking.coordinates)
    }
    
    // MARK: - Status Management
    func updateStatus(to newStatus: RideStatus, userLocation: CLLocation?) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
            rideStatus = newStatus
        }
        
        if newStatus == .inProgress {
            mapMode = .riding
            routePolyline = nil
            Task {
                await fetchNearByParking(userLocation: userLocation)
            }
        } else if newStatus == .completed {
            mapMode = .browse
        }
    }
    
    func resetRideState() {
        withAnimation {
            routePolyline = nil
            navigatingToScooter = nil
            selectedParkingAnnotation = nil
            parkingAnnotations = []
            isNavigationMode = false
            mapMode = .browse
            rideStatus = .reserved
        }
    }
    
    // MARK: - Computed Properties
    var formattedDuration: String {
        guard let route = routePolyline else { return "--" }
        let minutes = Int(route.expectedTravelTime / 60)
        return "\(minutes) min"
    }
    
    var formattedDistance: String {
        guard let route = routePolyline else { return "--" }
        let km = route.distance / 1000
        return String(format: "%.1f km", km)
    }
}
