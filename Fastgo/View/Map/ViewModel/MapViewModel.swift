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
    
    init (){
        bindLocation()
        bindAuthoriazationStatus()
        loadDummyAnnotation()
    }
    
    private func bindLocation() {
        locationManager.$currentLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.updateCamera(location)
                self?.reverseGeocode(location)
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
    
    private func reverseGeocode(_ location : CLLocation){
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(location) {[weak self] placemarks, error in
            
            if let error = error {
                print("Geocoding Error: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            
            let street = placemark.thoroughfare ?? ""
            let number = placemark.subThoroughfare ?? ""
            let city = placemark.locality ?? ""
            let state = placemark.administrativeArea ?? ""
            
            self?.userLocation = "\(number) \(street), \(city) \(state)" .trimmingCharacters(in: .whitespaces)
            print("User Address: \(self?.userLocation ?? "No Address")")
        }
    }
    
    private func loadDummyAnnotation(){
        annotations = [
            RideAnnotation(title: "Uru", coordinates: CLLocationCoordinate2D(latitude: 12.906070487006321, longitude: 77.60124826674085), type: .electricLight),
            RideAnnotation(title: "IIM", coordinates: CLLocationCoordinate2D(latitude: 12.894691319865407, longitude: 77.60125412506517), type: .electric),
            RideAnnotation(title: "Bhramas Brew", coordinates: CLLocationCoordinate2D(latitude: 12.893905832352848, longitude: 77.58642198094265), type: .electricHevy),
            RideAnnotation(title: "Silk Board", coordinates: CLLocationCoordinate2D(latitude: 12.91678053449925, longitude: 77.62335050972374), type: .electricHevy),
            RideAnnotation(title: "Racket Club", coordinates: CLLocationCoordinate2D(latitude: 12.901575845120508, longitude: 77.60617609477084), type: .electric),
            RideAnnotation(title: "Gopalan Mall", coordinates: CLLocationCoordinate2D(latitude: 12.914576086432705, longitude: 77.59957933318957), type: .electricLight),
            RideAnnotation(title: "Taco Street", coordinates: CLLocationCoordinate2D(latitude: 12.91102638703737, longitude: 77.609690107531), type: .electric)
        ]
    }
    
    func selectAnnotation(annotation : RideAnnotation) async{
        selectedAnnotation = annotation
        await drawRoute(to: annotation.coordinates)
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
