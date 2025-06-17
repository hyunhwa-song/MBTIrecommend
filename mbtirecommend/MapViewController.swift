//
//  MapViewController.swift
//  mbtirecommend
//
//  Created by 송현화 on 6/17/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var places: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        showAllPlacesOnMap()
        mapView.isZoomEnabled = true
    }

    private func showAllPlacesOnMap() {
        var annotations: [MKPointAnnotation] = []

        for place in places {
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = "\(place.category.title) | \(place.mbtiTypes.joined(separator: ", "))"
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: place.coordinates.latitude,
                longitude: place.coordinates.longitude
            )
            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "PlaceAnnotation"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
}

