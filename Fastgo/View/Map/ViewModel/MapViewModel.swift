//
//  MapViewModel.swift
//  Fastgo
//
//  Created by vishwas on 1/15/26.
//
import SwiftUI
import MapKit
import _MapKit_SwiftUI
import Combine

enum MapMode {
    case browse
    case navigateToScooter
    case riding
    case navigateToParking
}


@MainActor
class MapViewModel : ObservableObject {
    let locationManager = LocationManager()
    private let geocoder = CLGeocoder()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var cameraPosition : MapCameraPosition = .automatic
    @Published var userLocation : String = ""
    @Published var annotations : [ScooterAnnotation] = []
    @Published var selectedAnnotation : ScooterAnnotation?
    @Published var routePolyline : MKRoute?
    @Published var mapMode : MapMode = .browse
    @Published var rideStatus: RideStatus = .reserved
    
    @Published var parkingAnnotations: [ParkingAnnotation] = []
    @Published var navigatingToScooter: ScooterAnnotation?
    @Published var selectedParkingAnnotation: ParkingAnnotation?
    @Published var isNavigationMode: Bool = false
    
    private var hasCenteredOnce = false
    private var lastGeocodedLocation: CLLocation?
    private var scooterServices = ScooterServices.shared
    
    
    init (){
        bindLocation()
        bindAuthoriazationStatus()
    }
    
    private func bindLocation() {
        locationManager.$currentLocation
            .compactMap { $0 }
            .removeDuplicates(by: { old, new in
                old.distance(from: new) < 10
            })
            .sink { [weak self] location in
                guard let self else { return }
                
                if !self.hasCenteredOnce {
                    self.updateCamera(location)
                    self.hasCenteredOnce = true
                }
                
                self.reverseGeocode(location)
            }
            .store(in: &cancellables)
        
    }
    
    private func bindAuthoriazationStatus(){
        locationManager.$authorizationStatus
            .sink{[weak self] status in
                print("Authorization Status Changed : \(status.rawValue)")
                if status  == .authorizedAlways || status == .authorizedWhenInUse {
                    self?.locationManager.startUpdatingLocation()
                }
            }.store(in: &cancellables)
    }
    
    func requestPermission () {
        locationManager.requestPermission()
    }
    
    private func updateCamera(_ location : CLLocation){
        withAnimation{
            cameraPosition = .region(.init(center: location.coordinate, latitudinalMeters: 1300, longitudinalMeters: 1300))
        }
    }
    
    func centerUserLocation(){
        guard let location = locationManager.currentLocation else { return }
        
        updateCamera(location)
    }
    
    private func reverseGeocode(_ location: CLLocation) {
        if let last = lastGeocodedLocation,
           last.distance(from: location) < 50 {
            return
        }
        
        lastGeocodedLocation = location
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding Error: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            
            let street = placemark.thoroughfare ?? ""
            let number = placemark.subThoroughfare ?? ""
            let city = placemark.locality ?? ""
            let state = placemark.administrativeArea ?? ""
            
            self?.userLocation = "\(number) \(street), \(city) \(state)"
                .trimmingCharacters(in: .whitespaces)
            
            print("User Address: \(self?.userLocation ?? "No Address")")
        }
    }
    
    
    func getNearByScooters() async {
        do {
            let scooterDTOs = try await scooterServices.fetchScooters()
            
            annotations = scooterDTOs.map { dto in
                let scooter = Scooter(from: dto)
                return ScooterAnnotation(id: scooter.id, coordinate: scooter.coordinate, scooter: scooter)
            }
        } catch {
            print("Error fetching Scooters: \(error)")
        }
    }
    
    func selectAnnotation(annotation : ScooterAnnotation) {
        selectedAnnotation = annotation
    }
    
    func deSelectAnnotation(){
        selectedAnnotation = nil
        routePolyline = nil
    }
    
    func drawRoute(to destination: CLLocationCoordinate2D) async{
        guard let userLocation = locationManager.currentLocation else {
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
    
    func updateStatus(to newStatus: RideStatus) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
            rideStatus = newStatus
        }
        
        if newStatus == .inProgress {
            mapMode = .riding
            loadMockParkingSpots()
        } else if newStatus == .completed {
            mapMode = .browse
        }
    }
    
    func startNavigation(to scooter: ScooterAnnotation) {
        navigatingToScooter = scooter
        isNavigationMode = true
        mapMode = .navigateToScooter
        
        Task {
            await drawRoute(to: scooter.coordinates)
        }
    }
    
    func selectParkingAnnotation(_ parking: ParkingAnnotation) {
        selectedParkingAnnotation = parking
        mapMode = .navigateToParking
        
        Task {
            await drawRoute(to: parking.coordinates)
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
    
    private func loadMockParkingSpots() {
        guard let userLoc = locationManager.currentLocation else { return }
        
        let baseLat = userLoc.coordinate.latitude
        let baseLon = userLoc.coordinate.longitude
        
        parkingAnnotations = [
            ParkingAnnotation(
                id: "parking_1",
                coordinate: CLLocationCoordinate2D(latitude: baseLat + 0.002, longitude: baseLon + 0.001),
                name: "Central Parking",
                spotsAvailable: 8
            ),
            ParkingAnnotation(
                id: "parking_2",
                coordinate: CLLocationCoordinate2D(latitude: baseLat - 0.001, longitude: baseLon + 0.002),
                name: "Mall Parking",
                spotsAvailable: 3
            ),
            ParkingAnnotation(
                id: "parking_3",
                coordinate: CLLocationCoordinate2D(latitude: baseLat + 0.001, longitude: baseLon - 0.002),
                name: "Street Parking",
                spotsAvailable: 12
            ),
            ParkingAnnotation(
                id: "parking_4",
                coordinate: CLLocationCoordinate2D(latitude: baseLat - 0.002, longitude: baseLon - 0.001),
                name: "Station Parking",
                spotsAvailable: 1
            )
        ]
    }
    
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
    
    var currentUserCoordinate: CLLocationCoordinate2D? {
        locationManager.currentLocation?.coordinate
    }
}
