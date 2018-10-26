import UIKit
import ARKit

/// Protocol for AR navigation VC.
protocol ArNavigationViewControllerDelegate: class
{
    func onArNavigationDisabled()
}

/// View controller managing navigation using AR and device camera.
/// TODO: 
class ArNavigationViewController: UIViewController
{
    weak var delegate: ArNavigationViewControllerDelegate? = nil

    // MARK: - Public methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (_arEnabled)
        {
            _sceneView = ArNavigationView(vc: self)
            
            _sceneView.startup()
            
            view = _sceneView
        }
        else
        {
            view = ArNavigationErrorView(vc: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if (_arEnabled)
        {
            _sceneView.pause()
        }
        else
        {
            // do nothing
        }
    }
    
    func onSwitchModeButton()
    {
        if let delegate = delegate
        {
            delegate.onArNavigationDisabled()
        }
    }
    
    // MARK: - Private fields
    
    private var _arEnabled = ARConfiguration.isSupported
    private var _sceneView: ArNavigationView! = nil
}
