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
    
    init (){
        bindLocation()
        bindAuthoriazationStatus()
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
}
