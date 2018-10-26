import UIKit

/// Table cell used to display single atm data.
fileprivate class AtmInfoCell: UITableViewCell
{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// View displaying atm info.
class AtmInfoView: UIView, UITableViewDataSource
{
    init(vc: AtmInfoViewController?)
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
    
    func setAtmDataModel(model: AtmDataModel?)
    {
        _atmDataModel = model
    }
    
    // MARK: - UITableViewDataSource implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let provider = _atmDataModel?.getAtmDataProvider()
        {
            return provider.getAtmData().count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        if let item = _atmDataModel?.getAtmDataProvider()?.getAtmData()[indexPath.row]
        {
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = item.address
            cell.detailTextLabel?.text = _makeAtmInfoMessage(cashLevel: item.cashLevel)
        }
        
        return cell
    }
    
    // MARK: - Private methods
    
    /// Inits UI.
    private func _init()
    {
        _atmInfoTable = UITableView(frame: CGRect.zero)
        _atmInfoTable.translatesAutoresizingMaskIntoConstraints = false
        _atmInfoTable.register(AtmInfoCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        _atmInfoTable.dataSource = self
        addSubview(_atmInfoTable)
        
        let hideAtmInfoButtonItem = UIBarButtonItem(image: UIImage(named: "atm"), style: .plain, target: self, action: #selector(self._onHideAtmInfoButton))
        hideAtmInfoButtonItem.width = AppConstants.ICON_WIDTH
        
        let tmp = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        tmp.width = AppConstants.ICON_WIDTH
        let tmp2 = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        tmp2.width = AppConstants.ICON_WIDTH
        let tmp3 = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        tmp3.width = AppConstants.ICON_WIDTH
        let tmp4 = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        tmp4.width = AppConstants.ICON_WIDTH
        
        let toolbar = UiHelper.MakeToolbar(forItems:
            [
                UiHelper.MakeEmptyButton(),
                UiHelper.MakeEmptyButton(),
                UiHelper.MakeEmptyButton(),
                hideAtmInfoButtonItem,
                UiHelper.MakeEmptyButton()
            ])
        
        toolbar.backgroundColor = AppConstants.STANDARD_GRAY_COLOR
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(toolbar)
        
        let views =
        [
            "main": self,
            "tbl": _atmInfoTable,
            "tb": toolbar
        ]
        
        let metrics: [String: CGFloat] =
        [
            "tbHeight": AppConstants.TOOLBAR_HEIGHT
        ]
        
        let constraints =
        [
            "main":
            [
                "H:|[tb]|": NSLayoutFormatOptions(rawValue: 0),
                "H:|[tbl]|": NSLayoutFormatOptions(rawValue: 0),
                "V:|[tbl][tb(tbHeight)]|": NSLayoutFormatOptions(rawValue: 0)
            ]
        ]
        
        ConstraintsSetter.SetConstraints(viewsDictionary: views, metricsDictionary: metrics, constraintsDictionary: constraints)
    }
    
    /// Produces info message about atm's cash level.
    private func _makeAtmInfoMessage(cashLevel: Double) -> String
    {
        let baseCash = floor(Double(ATM_MAX_CASH_LIMIT) * cashLevel)
        var intCash = Int(baseCash / 10 )
        intCash = intCash * 10
        
        return "Наличные - \(intCash), заполнен на \(floor(cashLevel * 100))  %"
    }
    
    /// Hide atm info button callback.
    @objc private func _onHideAtmInfoButton()
    {
        if let vc = _vc
        {
            vc.onHideAtmInfoButton()
        }
    }
    
    // MARK: - Private constants
    
    private let ATM_MAX_CASH_LIMIT = 100000 // 100 000 rub
    private let CELL_IDENTIFIER = "Cell"
    
    // MARK: - Private fields
    private var _atmInfoTable: UITableView! = nil
    private var _vc: AtmInfoViewController? = nil
    private var _atmDataModel: AtmDataModel? = nil
}
