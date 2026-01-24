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

@MainActor
class MapViewModel : ObservableObject {
    let locationManager = LocationManager()
    private let geocoder = CLGeocoder()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var cameraPosition : MapCameraPosition = .automatic
    @Published var userLocation : String = ""
    @Published var annotations : [RideAnnotation] = []
    @Published var selectedAnnotation : RideAnnotation?
    @Published var routePolyline : MKRoute?
    
    private var hasCenteredOnce = false
    private var lastGeocodedLocation: CLLocation?
    
    
    init (){
        bindLocation()
        bindAuthoriazationStatus()
        loadDummyAnnotation()
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
    
    
    private func loadDummyAnnotation(){
        annotations = [
            RideAnnotation(title: "Uru Cruiser", vehicleDetails: .init(type: .seated, battery: 75, range: 22, perMinCost: 0.39, imageName: "scooter", coordinates: .init(latitude: 12.906070487006321, longitude: 77.60124826674085))),
            RideAnnotation(title: "IIM Speedster", vehicleDetails: .init(type: .standup, battery: 50, range: 15, perMinCost: 0.35, imageName: "scooter", coordinates: .init(latitude: 12.894691319865407, longitude: 77.60125412506517))),
            RideAnnotation(title: "Bhramas Brew Beast", vehicleDetails: .init(type: .offroad, battery: 90, range: 30, perMinCost: 0.45, imageName: "scooter", coordinates: .init(latitude: 12.893905832352848, longitude: 77.58642198094265))),
            RideAnnotation(title: "Silk Board Racer", vehicleDetails: .init(type: .sports, battery: 95, range: 32, perMinCost: 0.49, imageName: "scooter", coordinates: .init(latitude: 12.91678053449925, longitude: 77.62335050972374))),
            RideAnnotation(title: "Racket Club Glide", vehicleDetails: .init(type: .standup, battery: 60, range: 18, perMinCost: 0.35, imageName: "scooter", coordinates: .init(latitude: 12.901575845120508, longitude: 77.60617609477084))),
            RideAnnotation(title: "Gopalan Mall Commuter", vehicleDetails: .init(type: .seated, battery: 80, range: 25, perMinCost: 0.39, imageName: "scooter", coordinates: .init(latitude: 12.914576086432705, longitude: 77.59957933318957))),
            RideAnnotation(title: "Taco Street Explorer", vehicleDetails: .init(type: .offroad, battery: 40, range: 12, perMinCost: 0.45, imageName: "scooter", coordinates: .init(latitude: 12.91102638703737, longitude: 77.609690107531))),
            RideAnnotation(title: "Uru Cruiser", vehicleDetails: .init(type: .seated, battery: 75, range: 22, perMinCost: 0.39, imageName: "scooter", coordinates: .init(latitude: 37.333923550821474, longitude: -122.01485265580054))),
            RideAnnotation(title: "Jawed Habib", vehicleDetails: .init(type: .seated, battery: 75, range: 22, perMinCost: 0.39, imageName: "scooter", coordinates: .init(latitude: 23.81173046464357, longitude: 86.43283136607822)))
            
            
        ]
    }
    
    func selectAnnotation(annotation : RideAnnotation) {
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
}
