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
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Map Display Properties
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var userLocation: String = ""
    @Published var selectedAnnotation: ScooterAnnotation?
    
    private var hasCenteredOnce = false
    
    init() {
        bindLocation()
        bindAuthoriazationStatus()
    }
    
    // MARK: - Location Bindings
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
    
    private func bindAuthoriazationStatus() {
        locationManager.$authorizationStatus
            .sink { [weak self] status in
                print("Authorization Status Changed: \(status.rawValue)")
                if status == .authorizedAlways || status == .authorizedWhenInUse {
                    self?.locationManager.startUpdatingLocation()
                }
            }.store(in: &cancellables)
    }
    
    func requestPermission() {
        locationManager.requestPermission()
    }
    
    // MARK: - Camera Methods
    private func updateCamera(_ location: CLLocation) {
        withAnimation {
            cameraPosition = .region(.init(center: location.coordinate, latitudinalMeters: 1300, longitudinalMeters: 1300))
        }
    }
    
    func centerUserLocation() {
        guard let location = locationManager.currentLocation else { return }
        updateCamera(location)
    }
    
    func fitCameraToRoute(destination: CLLocationCoordinate2D) {
        guard let userLocation = locationManager.currentLocation else { return }
        
        let userCoord = userLocation.coordinate
        
        let minLat = min(userCoord.latitude, destination.latitude)
        let maxLat = max(userCoord.latitude, destination.latitude)
        let minLon = min(userCoord.longitude, destination.longitude)
        let maxLon = max(userCoord.longitude, destination.longitude)
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let latDelta = (maxLat - minLat) * 1.5
        let lonDelta = (maxLon - minLon) * 1.5
        
        let span = MKCoordinateSpan(
            latitudeDelta: max(latDelta, 0.01),
            longitudeDelta: max(lonDelta, 0.01)
        )
        
        withAnimation(.easeInOut(duration: 0.5)) {
            cameraPosition = .region(MKCoordinateRegion(center: center, span: span))
        }
    }
    
    // MARK: - Geocoding
    private func reverseGeocode(_ location: CLLocation) {
        Task {
            let address = await GeocodingService.shared.reverseGeocode(location)
            self.userLocation = address
            print("User Address: \(address)")
        }
    }
    
    // MARK: - Annotation Selection (for sheet)
    func selectAnnotation(annotation: ScooterAnnotation) {
        selectedAnnotation = annotation
    }
    
    func deSelectAnnotation() {
        selectedAnnotation = nil
    }
    
    // MARK: - Computed Properties
    var currentUserLocation: CLLocation? {
        locationManager.currentLocation
    }
    
    var currentUserCoordinate: CLLocationCoordinate2D? {
        locationManager.currentLocation?.coordinate
    }
}
