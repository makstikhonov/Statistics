//
//  MyFavouriteCountryMapViewCell.swift
//  Stats
//
//  Created by max on 11.07.2022.
//

import Foundation
import UIKit
import MapKit
import TinyConstraints
import CoreLocation

class MyFavouriteCountryMapViewCell: UICollectionViewCell{
    
    private  lazy var roundedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = RoundedView.radius
        view.layer.masksToBounds = false
        return view
    }()
    
    private let mapView : MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = MapView.interfaceStyle
        map.layer.cornerRadius = MapView.radius
        map.layer.masksToBounds = true
        return map
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        addSubview(roundedView)
        roundedView.edgesToSuperview()
	
        roundedView.addSubview(mapView)
        mapView.edgesToSuperview()
    }
    func configure(with data: Country) {
        addPins(data: data)
    }
    
    /// function  adds pins at the country location on the map
    /// - Parameter data: country data
    func addPins(data: Country) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(data.country) { placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            let countryPin = MKPointAnnotation()
            countryPin.title = data.country
            countryPin.coordinate = CLLocationCoordinate2D(
                latitude: lat ?? 0.0,
                longitude: lon ?? 0.0
            )
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(countryPin)
            let countryLocation = CLLocationCoordinate2D(latitude: lat ?? 0.0 , longitude: lon ?? 0.0)
            self.mapView.setCenter(countryLocation, animated: true)
        }
    }
}

extension MyFavouriteCountryMapViewCell {
    
    enum RoundedView {
        static let radius: CGFloat = 10.0
        static let backgroundColor: UIColor = .systemGray3
    }
    
    enum MapView {
        static let radius: CGFloat = 10.0
        static let interfaceStyle: UIUserInterfaceStyle = .dark
    }

}
