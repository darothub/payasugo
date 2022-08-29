//
//  LocationManager.swift
//  Permissions
//
//  Created by Abdulrasaq on 11/06/2022.
//

import Combine
import CoreLocation
import Foundation
import MapKit

public class LocationManager: NSObject, ObservableObject {
    var subscription = Set<AnyCancellable>()
    @Published var location: CLLocation?
    @Published public var locality:String = ""
    @Published public var locationPermissionDeniedOrRestricted = false
    let geocoder = CLGeocoder()
    
    public static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    
    public override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    }

    public func requestLocationPermission(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManager : CLLocationManagerDelegate{
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        geocoder.reverseGeocodeLocation(location, completionHandler: {[unowned self] placemarks, error in
            if let placeMark = placemarks?[0], city = placeMark.locality{
                locality = city
                print(locality)
            }
       
        })
    }
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
          case .restricted, .denied:
            Future<CLAuthorizationStatus, Never> { promise in
                promise(.success(status))
            }
            .receive(on: RunLoop.main)
            .map { $0 == .denied || $0 == .restricted }
            .assign(to: \.locationPermissionDeniedOrRestricted, on: self)
            .store(in: &subscription)
          case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
          case .notDetermined:
             break
        @unknown default:
            fatalError()
        }
    }
}
