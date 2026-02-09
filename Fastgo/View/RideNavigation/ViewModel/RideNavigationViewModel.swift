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
    
    // MARK: - Reservation Timer Properties
    @Published var remainingSeconds: Int = 600
    @Published var timer: Timer?
    @Published var didScanQRSuccessfully: Bool = false
    
    // MARK: - Ride Tracking Properties (for InProgress state)
    @Published var rideElapsedSeconds: Int = 0
    @Published var rideDistanceTraveled: CLLocationDistance = 0
    private var rideTimer: Timer?
    private var rideStartTime: Date?
    private var lastRideLocation: CLLocation?
    
    // MARK: - Completed Ride Data (for fare calculation)
    var completedRideDurationMinutes: Int = 0
    var completedRideDistanceKm: Double = 0
    
    // MARK: - Current Ride Properties (for backend sync)
    private(set) var currentRideId: String?
    private var rideStartLocation: CLLocation?
    
    // MARK: - Navigation Properties
    @Published var scooterAnnotations: [ScooterAnnotation] = []
    @Published var parkingAnnotations: [ParkingAnnotation] = []
    @Published var routePolyline: MKRoute?
    @Published var rideStatus: RideStatus = .reserved
    @Published var mapMode: MapMode = .browse
    @Published var navigatingToScooter: ScooterAnnotation?
    @Published var selectedParkingAnnotation: ParkingAnnotation?
    @Published var isNavigationMode: Bool = false
    
    // MARK: - Real-time Route Update Properties
    private var lastRouteCalculationLocation: CLLocation?
    private let routeUpdateDistanceThreshold: CLLocationDistance = 50 // meters
    private var isRecalculatingRoute: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let navigationServices = NavigationServices.shared
    private var userId : String? = AppStateManager.shared.currentUser?.id
    
    init() {
        observeQRScanNotification()
    }
    
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
    
    // MARK: - Ride Timer Methods (counts UP during InProgress)
    func startRideTimer(initialLocation: CLLocation?) {
        stopRideTimer()
        rideStartTime = Date()
        rideElapsedSeconds = 0
        rideDistanceTraveled = 0
        lastRideLocation = initialLocation
        
        rideTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                self.rideElapsedSeconds += 1
            }
        }
    }
    
    func stopRideTimer() {
        rideTimer?.invalidate()
        rideTimer = nil
    }
    
    func updateRideDistance(newLocation: CLLocation) {
        guard rideStatus == .inProgress else { return }
        
        if let lastLocation = lastRideLocation {
            let distance = newLocation.distance(from: lastLocation)
            // Only add distance if movement is reasonable (avoid GPS jitter)
            if distance >= 5 && distance <= 500 {
                rideDistanceTraveled += distance
            }
        }
        lastRideLocation = newLocation
    }
    
    // MARK: - Ride Tracking Formatted Properties
    var formattedRideDuration: String {
        let minutes = rideElapsedSeconds / 60
        let seconds = rideElapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var formattedRideDistance: String {
        let km = rideDistanceTraveled / 1000
        if km < 1 {
            return String(format: "%.0f m", rideDistanceTraveled)
        }
        return String(format: "%.2f km", km)
    }
    
    var currentScooterBattery: String {
        guard let scooter = navigatingToScooter?.scooter else { return "--" }
        return "\(scooter.battery)%"
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
        
        lastRouteCalculationLocation = userLocation
        
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
    
    // MARK: - Real-time Route Updates
    func updateRouteIfNeeded(userLocation: CLLocation?) async {
        guard let userLocation = userLocation else { return }
        
        // Only update during active navigation modes
        guard mapMode == .navigateToScooter || mapMode == .navigateToParking else { return }
        
        // Prevent concurrent recalculations
        guard !isRecalculatingRoute else { return }
        
        // Check if we've moved enough to warrant a recalculation
        if let lastLocation = lastRouteCalculationLocation {
            let distance = userLocation.distance(from: lastLocation)
            guard distance >= routeUpdateDistanceThreshold else { return }
        }
        
        isRecalculatingRoute = true
        defer { isRecalculatingRoute = false }
        
        // Determine destination based on current navigation mode
        let destination: CLLocationCoordinate2D?
        if mapMode == .navigateToScooter, let scooter = navigatingToScooter {
            destination = scooter.coordinates
        } else if mapMode == .navigateToParking, let parking = selectedParkingAnnotation {
            destination = parking.coordinates
        } else {
            destination = nil
        }
        
        guard let dest = destination else { return }
        
        await drawRoute(from: userLocation, to: dest)
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
            stopTimer()
            rideStartLocation = userLocation
            startRideTimer(initialLocation: userLocation)
            Task {
                await fetchNearByParking(userLocation: userLocation)
                await createRide()
            }
        } else if newStatus == .completed {
            completedRideDurationMinutes = rideElapsedSeconds / 60
            completedRideDistanceKm = rideDistanceTraveled / 1000
            stopRideTimer()
            mapMode = .browse
            Task {
                await completeRide(endLocation: userLocation)
            }
        }
    }
    
    // MARK: - Backend Ride Operations
    private func createRide() async {
        guard let scooterId = navigatingToScooter?.id,
              let userId = userId,
              let startLocation = rideStartLocation else {
            print("Missing data for ride creation")
            return
        }
        
        let startLocationName = await GeocodingService.shared.reverseGeocode(startLocation)
        
        let rideId = UUID().uuidString
        let ridePayload = Ride(
            id: rideId,
            userId: userId,
            scooterId: scooterId,
            status: .inProgress,
            startLatitude: startLocation.coordinate.latitude,
            startLongitude: startLocation.coordinate.longitude,
            endLatitude: nil,
            endLongitude: nil,
            startLocationName: startLocationName,
            endLocationName: nil,
            startedAt: rideStartTime ?? Date(),
            endedAt: nil,
            durationMinutes: 0,
            distanceKm: 0,
            totalFare: 0,
            promoCode: nil,
            discountAmount: nil,
            rideCompletedPhotoUrl: nil,
            createdAt: Date()
        )
        
        do {
            let ride = try await RideService.shared.createRide(userId: userId, payload: ridePayload)
            currentRideId = ride.id
            print("Ride Created Successfully - ID: \(ride.id)")
        } catch {
            print("Error Creating Ride: \(error)")
        }
    }
    
    private func completeRide(endLocation: CLLocation?) async {
        guard let rideId = currentRideId else {
            print("No active ride to complete")
            return
        }
        
        let perMinuteCost = navigatingToScooter?.scooter.perMinCost ?? 0.1
        let totalFare = Double(completedRideDurationMinutes) * perMinuteCost
        
        var endLocationName: String? = nil
        if let endLoc = endLocation {
            endLocationName = await GeocodingService.shared.reverseGeocode(endLoc)
        }
        
        let updatePayload = RideUpdatePayload(
            status: .completed,
            endLatitude: endLocation?.coordinate.latitude,
            endLongitude: endLocation?.coordinate.longitude,
            endLocationName: endLocationName,
            endedAt: Date(),
            durationMinutes: completedRideDurationMinutes,
            distanceKm: completedRideDistanceKm,
            totalFare: totalFare
        )
        
        do {
            try await RideService.shared.updateRide(rideId: rideId, payload: updatePayload)
            print("Ride Completed Successfully - Duration: \(completedRideDurationMinutes) min, Distance: \(String(format: "%.2f", completedRideDistanceKm)) km, Fare: $\(String(format: "%.2f", totalFare))")
        } catch {
            print("Error Completing Ride: \(error)")
        }
    }
    
    func resetRideState() {
        stopTimer()
        stopRideTimer()
        withAnimation {
            routePolyline = nil
            navigatingToScooter = nil
            selectedParkingAnnotation = nil
            parkingAnnotations = []
            isNavigationMode = false
            mapMode = .browse
            rideStatus = .reserved
            lastRouteCalculationLocation = nil
            rideElapsedSeconds = 0
            rideDistanceTraveled = 0
            lastRideLocation = nil
            rideStartTime = nil
            currentRideId = nil
            rideStartLocation = nil
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
