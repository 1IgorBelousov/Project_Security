import UIKit

protocol AtmInfoViewControllerDelegate: class
{
    func onHideAtmInfo()
}

class AtmInfoViewController: UIViewController
{
    // MARK: - Public properties.
    weak var delegate: AtmInfoViewControllerDelegate? = nil
    
    // MARK: - Init
    
    init(model: AtmDataModel?)
    {
        super.init(nibName: nil, bundle: nil)
        
        _atmDataModel = model
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        _init()
    }
    
    func onHideAtmInfoButton()
    {
        if let delegate = delegate
        {
            delegate.onHideAtmInfo()
        }
    }
    
    // MARK: - Private methods
    
    private func _init()
    {
        let atmInfoView = AtmInfoView(vc: self)
        atmInfoView.setAtmDataModel(model: _atmDataModel)
        view = atmInfoView
    }
    
    // MARK: - Private fields
    private var _atmDataModel: AtmDataModel? = nil
}
