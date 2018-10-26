import UIKit
import MapKit

protocol DirectionsViewDataSource
{
    func getRoutePartsCount() -> Int
    func getDirectionsCount(routePart: Int) -> Int
    
}

fileprivate class DirectionCell: UITableViewCell
{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _init()
    {
        
    }
}

class DirectionsView: UIView, UITableViewDataSource, UITableViewDelegate, RouteModelDelegate
{
    
    
    init(routeModel: RouteModel?)
    {
        super.init(frame: CGRect.zero)
        
        _routeModel = routeModel
        _routeModel?.addDelegate(delegate: self)
        
        _init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setRouteModel(routeModel: RouteModel?)
    {
        _routeModel = routeModel
        _routeModel?.addDelegate(delegate: self)
        
        _directionsTable.reloadData()
    }
    
    // MARK: - RouteModelDelegate implementation
    
    func onRouteBuilt()
    {
        DispatchQueue.main.async
        {
            self._directionsTable.reloadData()
        }
        
    }

    func onInstructionSelected()
    {
        if let modelIndex = _routeModel?.getSelectedRouteInstructionIndex()
        {
            if let tableSelectedIndex = _directionsTable.indexPathForSelectedRow
            {
                if (modelIndex != tableSelectedIndex)
                {
                    // update index
                    _directionsTable.selectRow(at: modelIndex, animated: true, scrollPosition: .middle)
                }
            }
        }
    }
    
    func onReset()
    {
        _directionsTable.reloadData()
    }
    
    func onFailure(error: Error)
    {
        _directionsTable.reloadData()
    }
    
    // MARK: - UITableViewDataSource implementation
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if let routeParts = _routeModel?.getRouteParts()
        {
            return routeParts.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let routeParts = _routeModel?.getRouteParts()
        {
            return routeParts[section].steps.count - 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return AppConstants.TOOLBAR_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        if let routeParts = _routeModel?.getRouteParts()
        {
            cell.textLabel?.text = routeParts[indexPath.section].steps[indexPath.row + 1].instructions
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if let routePoints = _routeModel?.getRoutePoints()
        {
            return routePoints[section].address
        }
        return ""
    }
    
    // MARK: - UITableViewDelegate implementation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        _routeModel?.setSelectedRouteInstructionIndex(instructionIndex: indexPath)
    }
    
    // MARK: - Private methods
    
    /// Inits UI.
    private func _init()
    {
        _directionsTable.translatesAutoresizingMaskIntoConstraints = false
        _directionsTable.register(DirectionCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        _directionsTable.dataSource = self
        _directionsTable.delegate = self
        addSubview(_directionsTable)
        
        let views =
        [
            "main": self,
            "dirTbl": _directionsTable
        ]
        
        let constraints =
        [
            "main":
            [
                "H:|[dirTbl]|": NSLayoutFormatOptions(rawValue: 0),
                "V:|[dirTbl]|": NSLayoutFormatOptions(rawValue: 0)
            ]
        ]
        
        ConstraintsSetter.SetConstraints(viewsDictionary: views, metricsDictionary: nil, constraintsDictionary: constraints)
    }
    
    // MARK: - Private fields
    
    private let CELL_IDENTIFIER = "cell"
    
    private var _directionsTable = UITableView()
    private weak var _routeModel: RouteModel? = nil
}

