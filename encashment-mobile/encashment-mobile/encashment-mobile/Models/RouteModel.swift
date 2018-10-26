import Foundation

import CoreLocation
import MapKit

/// Protocol for delegates tracking route model changes.
protocol RouteModelDelegate: class
{
    func onRouteBuilt()
    func onInstructionSelected()
    func onReset()
    func onFailure(error: Error)
}

/// Model class keeping data about actual route and its instructions.
class RouteModel
{
    // MARK: - Init
    init(atmDataModel: AtmDataModel?)
    {
        _atmDataModel = atmDataModel
    }
    
    // MARK: - Public methods
    
    /// Adds model listener.
    func addDelegate(delegate: RouteModelDelegate?)
    {
        if (delegate != nil)
        {
            _delegates.append(delegate!)
        }
    }
    
    /// Builds route for specified start point.
    func buildRoute(startPoint: WCoord)
    {
        let routeLoader: WAtmRouteLoader = WAtmRouteLoader(dataProvider: _atmDataModel?.getAtmDataProvider())
        _routePoints = routeLoader.getAtmRoute(forPoint: startPoint)
        
        if let routePoints = _routePoints
        {
            // having n points we always have n-1 lines connecting them
            _remainingRouteParts = routePoints.count
            _routeParts = Array<MKRoute>(repeating: MKRoute(), count: _remainingRouteParts)
            
            self._getRoutePart(start: startPoint, end: routePoints[0].coords, index: 0)
            
            for i in 0 ..< routePoints.count-1
            {
                self._getRoutePart(start: routePoints[i].coords, end: routePoints[i+1].coords, index: i+1)
            }
        }
    }
    
    /// Sets new selected instruction index.
    func setSelectedRouteInstructionIndex(instructionIndex: IndexPath)
    {
        _selectedInstructionIndex = instructionIndex
        _notifyDelegatesOnInstructionSelected()
    }
    
    /// Gets selected instruction index.
    func getSelectedRouteInstructionIndex() -> IndexPath?
    {
        return _selectedInstructionIndex
    }
    
    /// Gets actual route points.
    func getRoutePoints() -> [WAtmData]?
    {
        return _routePoints
    }
    
    /// Gets last built route.
    func getRouteParts() -> [MKRoute]?
    {
        return _routeParts
    }
    
    /// Clears all the data.
    func reset()
    {
        _routeParts = nil
        _routePoints = nil
        _selectedInstructionIndex = nil
        
        _notifyDelegatesOnReset()
    }
    
    // MARK: - Private methods
    
    /// Decreases required route parts by 1.
    private func _decrementRemainingParts()
    {
        _internalQueue.sync
        {
            _remainingRouteParts = _remainingRouteParts - 1
            
            // route is ready, trigger update
            if (_remainingRouteParts == 0)
            {
                _notifyDelegatesOnRouteBuilt()
            }
        }
    }
    
    /// Notifies that route was successfully built.
    private func _notifyDelegatesOnRouteBuilt()
    {
        for delegate in _delegates
        {
            delegate?.onRouteBuilt()
        }
    }
    
    /// Notifies that new instruction was selected.
    private func _notifyDelegatesOnInstructionSelected()
    {
        for delegate in _delegates
        {
            delegate?.onInstructionSelected()
        }
    }
    
    /// Notifies that reset occurred.
    private func _notifyDelegatesOnReset()
    {
        for delegate in _delegates
        {
            delegate?.onReset()
        }
    }
    
    /// Notifies that error occurred.
    private func _notifyDelegatesOnFailure(error: Error)
    {
        for delegate in _delegates
        {
            delegate?.onFailure(error: error)
        }
    }
    
    /// Asynchronously calculates i-th route part from start to end point.
    private func _getRoutePart(start: WCoord, end: WCoord, index: Int)
    {
        let dirRequest = MKDirectionsRequest()
        let startMark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(start.x), CLLocationDegrees(start.y)))
        let endMark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(end.x), CLLocationDegrees(end.y)))
        
        dirRequest.source = MKMapItem(placemark: startMark)
        dirRequest.destination = MKMapItem(placemark: endMark)
        dirRequest.transportType = .automobile
        
        let weakSelf = self
        
        let directions = MKDirections(request: dirRequest)
        directions.calculate(completionHandler: {response, error in
            
            if (error == nil)
            {
                // all is ok, remember new route part
                weakSelf._routeParts![index] = response!.routes[0] as MKRoute
                weakSelf._decrementRemainingParts()
            }
            else
            {
                // error - abort calculations
                directions.cancel()
                weakSelf._remainingRouteParts = 0
                weakSelf._notifyDelegatesOnFailure(error: error!)
            }
        })
        
    }
    
    // MARK: - Private fields.
    
    // need that to correctly track remaining route parts and call update when necessary
    private var _remainingRouteParts: Int = 0
    private let _internalQueue: DispatchQueue = DispatchQueue(label: "sync_queue")
    
    
    private var _delegates: [RouteModelDelegate?] = []
    private weak var _atmDataModel: AtmDataModel? = nil
    
    private var _routePoints: [WAtmData]? = nil
    private var _routeParts: [MKRoute]? = nil
    private var _selectedInstructionIndex: IndexPath? = nil
    
    private var _group = DispatchGroup()
}
