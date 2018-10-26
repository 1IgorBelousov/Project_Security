import UIKit
import MapKit
import CoreLocation

/// Protocol for main VC delegate.
protocol MainViewControllerDelegate: class
{
    func onArNavigationEnabled()
    func onShowAtmInfo()
}

/// View controller showing main app view.
class MainViewController: UIViewController
{
    weak var delegate: MainViewControllerDelegate? = nil
    
    init(routeModel: RouteModel?)
    {
        super.init(nibName: nil, bundle: nil)
        
        _routeModel = routeModel
        _mainView = MainView(vc: self)
        _mainView.setRouteModel(routeModel: _routeModel)
        _routeModel?.addDelegate(delegate: _mainView)
        _startLocationTrackingTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view = _mainView
        _waitVC.modalPresentationStyle = .overCurrentContext
        _waitVC.preferredContentSize = CGSize(width: 80, height: 80)
        
    }
    
    /// Registers location changing.
    func onLocationUpdate(location: CLLocation?)
    {
        _location = location
    }
    
    /// Registers 'build route' button click
    func onBuildRouteButton()
    {
        if let loc: CLLocation = _location
        {
            // reset model - clear previous results
            _routeModel?.reset()
            
            // start building new route
            _routeModel?.buildRoute(startPoint: WCoord(x: loc.coordinate.latitude, withY: loc.coordinate.longitude))
            
            // show wait message
            _waitVC.setMessage(message: AppConstants.WAIT_MESSAGE)
            self.present(_waitVC, animated: true, completion: nil)
        }
        
    }
    
    /// Notifies that route was built.
    func onRouteBuilt()
    {
        DispatchQueue.main.async
        {
            self._waitVC.dismiss(animated: true, completion: nil)
        }
    }
    
    /// Registers 'switch mode' button click.
    func onSwitchModeButton()
    {
        if let delegate = delegate
        {
            delegate.onArNavigationEnabled()
        }
    }
    
    /// Registers 'show directions' button click.
    func onShowDirectionsButton()
    {
        _mainView.showDirections()
    }
    
    /// Registers 'clear' button click
    func onClearButton()
    {
        _routeModel?.reset()
    }
    
    /// Registers 'show atm info' button click.
    func onShowAtmInfoButton()
    {
        delegate?.onShowAtmInfo()
    }
    
    /// Triggers when some error occurred.
    func onErrorOccurred(error: Error)
    {
        DispatchQueue.main.async
        {
            self._waitVC.dismiss(animated: true, completion: {
                let alert = UIAlertController(title: AppConstants.ERROR_VIEW_TITLE, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AppConstants.ERROR_OK, style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    // MARK: - Private methods
    
    /// Start sending data about current location.
    private func  _startLocationTrackingTimer()
    {
        DispatchQueue.main.async
        {
            Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { _ in
                HttpRequestHelper.SendLocationData(location: self._location)
                print("tick")
            })
        }
    }
    
    // MARK: - Private fields
    
    private let _waitVC: WaitViewController = WaitViewController()
    
    private var _location: CLLocation? = nil
    private var _routeModel: RouteModel? = nil
    private var _mainView: MainView! = nil
}
