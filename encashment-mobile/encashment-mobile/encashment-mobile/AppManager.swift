import UIKit

/// Main app dispatcher managing its state.
class AppManager: LoginViewControllerDelegate, MainViewControllerDelegate, ArNavigationViewControllerDelegate, AtmInfoViewControllerDelegate, AppModelDelegate
{
    init(window: UIWindow)
    {
        _window = window
        
        _initSosTrigger()
        _appModel.delegate = self
    }
    
    // MARK: - Public methods
    
    /// Starts app.
    func startup()
    {
        do
        {
            try changeState(key: LOGIN_KEY)
        }
        catch
        {
            // do error handling
        }
    }
    
    /// Updates app state.
    func changeState(key: String) throws
    {
        switch key
        {
        case LOGIN_KEY:
            let vc = LoginViewController()
            vc.delegate = self
            _window.rootViewController = vc
        case MAIN_KEY:
            let vc = MainViewController(routeModel: _appModel.getRouteModel())
            vc.delegate = self
            _window.rootViewController = vc
        case AR_KEY:
            let vc = ArNavigationViewController()
            vc.delegate = self
            _window.rootViewController = vc
        case ATM_KEY:
            let vc = AtmInfoViewController(model: _appModel.getAtmDataModel())
            vc.delegate = self
            _window.rootViewController = vc
        default:
            throw NSError(domain: "Not valid app state key", code: 1, userInfo: nil)
        }
    }
    
    // MARK: - AppModelDelegate implementation
    
    func onSos()
    {
        _window.isUserInteractionEnabled = false
    }
    
    // MARK: - LoginViewControllerDelegate implementation
    
    func onLogin(user: String, password: String)
    {
        if (_appModel.isValidCredentials(login: user, password: password))
        {
            do
            {
                try changeState(key: MAIN_KEY)
            }
            catch
            {
                // do error handling
            }
        }
    }
    
    // MARK: - MainViewControllerDelegate implementation
    
    func onArNavigationEnabled()
    {
        do
        {
            try changeState(key: AR_KEY)
        }
        catch
        {
            // do error handling
        }
    }
    
    func onShowAtmInfo()
    {
        do
        {
            try changeState(key: ATM_KEY)
        }
        catch
        {
            // do error handling
        }
    }
    
    // MARK: - ArNavigationViewControllerDelegate implementation
    
    func onArNavigationDisabled()
    {
        do
        {
            try changeState(key: MAIN_KEY)
        }
        catch
        {
            // do error handling
        }
    }
    
    // MARK: - AtmInfoViewControllerDelegate implementation
    
    func onHideAtmInfo()
    {
        do
        {
            try changeState(key: MAIN_KEY)
        }
        catch
        {
            // error handling
        }
    }
    
    // MARK: - Private methods
    
    /// Sets secret SOS trigger.
    /// User must quickly tap 5 times to send SOS signal.
    private func _initSosTrigger()
    {
        let tapGestureRecoginzer = UITapGestureRecognizer(target: self, action: #selector(self._onSosTrigger))
        tapGestureRecoginzer.numberOfTapsRequired = SOS_TAPS_REQUIRED
        
        _window.addGestureRecognizer(tapGestureRecoginzer)
    }
    
    /// SOS trigger callback.
    @objc private func _onSosTrigger()
    {
        _appModel.triggerSosSignal()
    }
    
    // MARK: - Private constants
    
    private let SOS_TAPS_REQUIRED = 5
    
    private let LOGIN_KEY: String = "/login"
    private let MAIN_KEY: String = "/main"
    private let AR_KEY: String = "/ar_navigation"
    private let ATM_KEY: String = "/atms"
    
    // MARK: - Private properties
    
    private var _window: UIWindow! = nil
    private let _appModel = AppModel()
}
