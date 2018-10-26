import Foundation
import UIKit
import MapKit
import CoreLocation

/// Main view where user works.
class MainView: UIView, CLLocationManagerDelegate, MKMapViewDelegate, UIToolbarDelegate, RouteModelDelegate
{
    init(vc: MainViewController)
    {
        super.init(frame: CGRect.zero)
        
        _vc = vc
        _init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    /// Sets route model to listen and update.
    func setRouteModel(routeModel: RouteModel?)
    {
        _routeModel = routeModel
        _directionsView.setRouteModel(routeModel: routeModel)
    }
    
    /// Shows directions window.
    func showDirections()
    {
        _isDirectionsWindowOpen = !_isDirectionsWindowOpen
        _directionsView.isHidden = !_isDirectionsWindowOpen
        _directionsView.setNeedsDisplay()
    }
    
    /// Clears all displayed data.
    func clearAll()
    {
        // clear annotations except user location
        let userAnnotation = _mapView.userLocation
        
        var annotations = _mapView.annotations
        annotations.remove(at: annotations.index(where: {item -> Bool in
            return item.isEqual(userAnnotation)
        })!)
        
        _mapView.removeAnnotations(annotations)
        
        // clear polylines
        for overlay in _mapView.overlays
        {
            if (overlay is MKPolyline)
            {
                _mapView.remove(overlay)
            }
        }
    }
    
    // MARK: - RouteModelDelegate implementation
    
    func onRouteBuilt()
    {
        DispatchQueue.main.async
        {
            // draw atms
            if let atms = self._routeModel?.getRoutePoints()
            {
                for i in 0 ..< atms.count-1
                {
                    self._addStopAnnotation(point: atms[i].coords, address: atms[i].address, index: i+1)
                }
                
                self._addFinishAnnotation(point: atms.last!.coords, address: atms.last!.address)
            }
            
            // draw lines
            if let result = self._routeModel?.getRouteParts()
            {
                for routePart in result
                {
                    self._mapView.add(routePart.polyline)
                }
                
            }
            
            // notify view controller
            if let vc = self._vc
            {
                vc.onRouteBuilt()
            }
        }
    }
    
    func onInstructionSelected()
    {
        DispatchQueue.main.async
        {
            if let instructionIndex = self._routeModel?.getSelectedRouteInstructionIndex()
            {
                if let routeParts = self._routeModel?.getRouteParts()
                {
                    let pointToCenter = routeParts[instructionIndex.section].steps[instructionIndex.row+1].polyline.coordinate
                    
                    self._mapView.setCenter(pointToCenter, animated: true)
                }
            }
        }
    }
    
    func onReset()
    {
        clearAll()
    }
    
    func onFailure(error: Error)
    {
        if let vc = _vc
        {
            vc.onErrorOccurred(error: error)
        }
    }
    
    // MARK: - CLLocationManagerDelegate implementation
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        if let vc = _vc
        {
            vc.onLocationUpdate(location: manager.location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    // MARK: - MKMapViewDelegate implementation
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let myLineRenderer = MKPolylineRenderer(overlay: overlay)
        myLineRenderer.strokeColor = UIColor(red: 23/255, green: 125/255, blue: 247/255, alpha: 1.0)
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
    // MARK: - Private methods
    
    /// Inits UI.
    private func _init()
    {
        // location manager
        _locationManager.activityType = .automotiveNavigation
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.distanceFilter = 5
        _locationManager.requestAlwaysAuthorization()
        _locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            _locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        
        _mapView = MKMapView()
        _mapView.translatesAutoresizingMaskIntoConstraints = false
        _mapView.delegate = self
        _mapView.mapType = MKMapType.standard
        _mapView.isZoomEnabled = true
        _mapView.isScrollEnabled = true
        _mapView.showsUserLocation = true
        addSubview(_mapView)
        _setupMapView()
        
        _directionsView = DirectionsView(routeModel: _routeModel)
        _directionsView.translatesAutoresizingMaskIntoConstraints = false
        _directionsView.isHidden = true
        addSubview(_directionsView)
        
        let buildRouteButtonItem = UIBarButtonItem(image: UIImage(named: "build_route"), style: .plain, target: self, action: #selector(self._onBuildRouteButton))
        
        let showDirectionsButtonItem = UIBarButtonItem(image: UIImage(named: "directions"), style: .plain, target: self, action: #selector(self._onShowDirectionsButton))
        
        let switchModeButtonItem = UIBarButtonItem(image: UIImage(named: "switch_mode"), style: .plain, target: self, action: #selector(self._onSwitchModeButton))
        
        let clearButtonItem = UIBarButtonItem(image: UIImage(named: "clear"), style: .plain, target: self, action: #selector(self._onClearButton))
        
        let atmInfoButtonItem = UIBarButtonItem(image: UIImage(named: "atm"), style: .plain, target: self, action: #selector(self._onShowAtmInfoButton))
        
        let toolbar = UiHelper.MakeToolbar(forItems: [buildRouteButtonItem, showDirectionsButtonItem, clearButtonItem, atmInfoButtonItem, switchModeButtonItem])
        toolbar.backgroundColor = AppConstants.STANDARD_GRAY_COLOR
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.delegate = self
        addSubview(toolbar)
        
        let views: [String: Any] =
        [
            "main": self,
            "map": _mapView,
            "tb": toolbar,
            "dirs": _directionsView
        ]
        
        let metrics: [String: CGFloat] =
        [
            "topOffset": 150.0,
            "iconWidth": 29.0,
            "iconHeight": 29.0,
            "btnBottomOffset": 48.0,
            "btnBorderOffset": 16.0,
            "tbHeight": 44.0,
            "dirsHeight": 180.0
        ]
        
        let constraints: [String: [String: NSLayoutFormatOptions]] =
        [
            "main":
            [
                "H:|[map]|": NSLayoutFormatOptions(rawValue: 0),
                "H:|[tb]|": NSLayoutFormatOptions(rawValue: 0),
                "V:|[map][tb(tbHeight)]|": NSLayoutFormatOptions(rawValue: 0),
                "H:|[dirs]|": NSLayoutFormatOptions(rawValue: 0),
                "V:|-(>=0)-[dirs(dirsHeight)][tb]|": NSLayoutFormatOptions(rawValue: 0)
            ]
        ]
        
        ConstraintsSetter.SetConstraints(viewsDictionary: views, metricsDictionary: metrics, constraintsDictionary: constraints)
    }
    
    /// Performs setup for map.
    private func _setupMapView()
    {
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: _locationManager.location!.coordinate, span: span)
        _mapView.setRegion(region, animated: true)
        if let coor = _mapView.userLocation.location?.coordinate{
            _mapView.setCenter(coor, animated: true)
        }
    }

    /// Adds map annotation about atm stop.
    private func _addStopAnnotation(point: WCoord, address: String, index: Int)
    {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
        annotation.title = "Банкомат №" + String(index)
        annotation.subtitle = address
        
        _mapView.addAnnotation(annotation)
    }
    
    /// Adds map annotation about finish point.
    private func _addFinishAnnotation(point: WCoord, address: String)
    {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
        annotation.title = "Финиш"
        annotation.subtitle = address
        
        _mapView.addAnnotation(annotation)
    }
    
    /// Build route button callback.
    @objc private func _onBuildRouteButton()
    {
        if let vc = _vc
        {
            vc.onBuildRouteButton()
        }
    }
    
    /// Switch mode button callback.
    @objc private func _onSwitchModeButton()
    {
        if let vc = _vc
        {
            vc.onSwitchModeButton()
        }
    }
    
    /// Show directions button callback.
    @objc private func _onShowDirectionsButton()
    {
        if let vc = _vc
        {
            vc.onShowDirectionsButton()
        }
    }
    
    /// Clear button callback.
    @objc private func _onClearButton()
    {
        if let vc = _vc
        {
            vc.onClearButton()
        }
    }
    
    /// Show atm info button callback.
    @objc private func _onShowAtmInfoButton()
    {
        if let vc = _vc
        {
            vc.onShowAtmInfoButton()
        }
    }
    
    // MARK: - Private fields
    
    private var _mapView: MKMapView! = nil
    private var _routeModel: RouteModel? = nil
    private var _directionsView: DirectionsView! = nil
    private var _locationManager: CLLocationManager = CLLocationManager()
    private var _vc: MainViewController? = nil
    
    // view state
    private var _isDirectionsWindowOpen = false
}
