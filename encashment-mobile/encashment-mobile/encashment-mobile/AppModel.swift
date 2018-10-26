import Foundation

/// App model delegate to handle events.
protocol AppModelDelegate
{
    func onSos()
}

/// App model class.
class AppModel
{
    var delegate: AppModelDelegate? = nil
    
    init()
    {
        _atmDataModel = AtmDataModel(atmDataFileName: ATM_DATA_FILE_NAME)
        _routeModel = RouteModel(atmDataModel: _atmDataModel)
    }
    
    func getAtmDataModel() -> AtmDataModel?
    {
        return _atmDataModel
    }
    
    func getRouteModel() -> RouteModel?
    {
        return _routeModel
    }
    
    func isValidCredentials(login: String?, password: String?) -> Bool
    {
        if (login == nil || password == nil)
        {
            return false
        }
        
        return login! == LOGIN && password! == PASSWORD
    }
    
    func triggerSosSignal()
    {
        // send http-request about SOS
        HttpRequestHelper.SendSos()
        
        // notify delegate
        delegate?.onSos()
    }
    
    // MARK: - Private constants
    
    // Hardcoded credentials
    private let ATM_DATA_FILE_NAME = "addresses.txt"
    private let LOGIN = "Admin"
    private let PASSWORD = "260512"
    
    // models
    private var _atmDataModel: AtmDataModel! = nil
    private var _routeModel: RouteModel! = nil
}
