import Foundation

/// Model class keeping data about atms.
class AtmDataModel
{
    // MARK: - Init
    init(atmDataFileName: String)
    {
        _dataProvider = WAtmDataProvider(dataFile: atmDataFileName)
    }
    
    // MARK: - Public methods
    
    func getAtmDataProvider() -> WAtmDataProvider?
    {
        return _dataProvider
    }
    
    // MARK: - Private fields
    
    private var _dataProvider: WAtmDataProvider! = nil
}
