//
//  LocationManager.swift
//  Fastgo
//
//  Created by vishwas on 1/15/26.
//
import Foundation
import MapKit

final class LocationManager :NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentLocation : CLLocation?
    @Published var authorizationStatus : CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        self.authorizationStatus = manager.authorizationStatus
        
    }
    
    func requestPermission(){
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        switch manager.authorizationStatus {
        case .notDetermined:
            requestPermission()
            print("When user did not yet determined")
        case .restricted:
            stopUpdatingLocation()
            print("Restricted by parental control")
        case .denied:
            stopUpdatingLocation()
            print("When user select option Dont't Allow")
        case .authorizedAlways:
            startUpdatingLocation()
            print("When user select option Change to Always Allow")
        case .authorizedWhenInUse:
            startUpdatingLocation()
            print("When user select option Allow While Using App or Allow Once")
            manager.requestAlwaysAuthorization()
        default:
            print("default")
            stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations : [CLLocation] ){
        guard let location = locations.last else { return }
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error : Error){
        print("Location Error: \(error)")
    }
}
