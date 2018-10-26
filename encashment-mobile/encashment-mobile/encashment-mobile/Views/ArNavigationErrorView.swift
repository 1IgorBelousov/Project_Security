import UIKit

class ArNavigationErrorView: UIView
{
    init(vc: ArNavigationViewController?)
    {
        super.init(frame: CGRect.zero)
        
        _init()
        _vc = vc
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    /// Inits UI.
    private func _init()
    {
        backgroundColor = AppConstants.STANDARD_GRAY_COLOR
        
        let disclaimer = UILabel()
        disclaimer.translatesAutoresizingMaskIntoConstraints = false
        disclaimer.textColor = UIColor.blue
        disclaimer.text = "Ваше устройство не поддерживает AR-технологию."
        disclaimer.lineBreakMode = .byWordWrapping
        disclaimer.numberOfLines = 0
        addSubview(disclaimer)
        
        let switchModeButtonItem = UIBarButtonItem(image: UIImage(named: "switch_mode"), style: .plain, target: self, action: #selector(self._onSwitchModeButton))
        switchModeButtonItem.width = AppConstants.ICON_WIDTH
        
        let toolbar = UiHelper.MakeToolbar(forItems:
            [
                UiHelper.MakeEmptyButton(),
                UiHelper.MakeEmptyButton(),
                UiHelper.MakeEmptyButton(),
                UiHelper.MakeEmptyButton(),
                switchModeButtonItem
            ])
        toolbar.backgroundColor = AppConstants.STANDARD_GRAY_COLOR
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(toolbar)
        
        let views =
        [
            "main": self,
            "lbl": disclaimer,
            "tb": toolbar
        ]
        
        let metrics: [String: CGFloat] =
        [
            "lblWidth": 230,
            "lblHeight": 28,
            "tbHeight": AppConstants.TOOLBAR_HEIGHT
        ]
        
        let constraints =
        [
            "main":
            [
                "H:[main]-(<=1)-[lbl(lblWidth)]": NSLayoutFormatOptions.alignAllCenterY,
                "V:[main]-(<=1)-[lbl(>=lblHeight)]": NSLayoutFormatOptions.alignAllCenterX,
                "H:|[tb]|": NSLayoutFormatOptions(rawValue: 0),
                "V:[lbl]-(>=0)-[tb(tbHeight)]|": NSLayoutFormatOptions(rawValue: 0)
            ]
        ]
        
        ConstraintsSetter.SetConstraints(viewsDictionary: views, metricsDictionary: metrics, constraintsDictionary: constraints)
    }
    
    /// Switch mode button callback.
    @objc private func _onSwitchModeButton()
    {
        if let vc = _vc
        {
            vc.onSwitchModeButton()
        }
    }
    
    // MARK: - Private fields
    
    private weak var _vc: ArNavigationViewController? = nil
}
