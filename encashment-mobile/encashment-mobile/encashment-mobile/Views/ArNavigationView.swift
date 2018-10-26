import Foundation
import UIKit
import ARKit

/// View responsible for displaying route in AR.
class ArNavigationView: UIView
{
    init(vc: ArNavigationViewController?)
    {
        super.init(frame: CGRect.zero)
        
        _vc = vc
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    /// Starts AR session.
    func startup()
    {
        let configuration = ARWorldTrackingConfiguration()
        _arView.session.run(configuration)
    }
    
    /// Pauses AR session.
    func pause()
    {
        _arView.session.pause()
    }
    
    // MARK: - Private methods
    
    /// Inits UI.
    private func _init()
    {
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
        
        _arView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(_arView)
        
        let views =
        [
            "main": self,
            "tb": toolbar,
            "ar": _arView
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
                "H:|[ar]|": NSLayoutFormatOptions(rawValue: 0),
                "V:|[ar][tb(tbHeight)]|": NSLayoutFormatOptions(rawValue: 0)
            ]
        ]
        
        ConstraintsSetter.SetConstraints(viewsDictionary: views, metricsDictionary: metrics, constraintsDictionary: constraints)
    }
    
    /// Switch mode button callback
    @objc private func _onSwitchModeButton()
    {
        if let vc = _vc
        {
            vc.onSwitchModeButton()
        }
    }
    
    // MARK: - Private fields
    
    private let _arView = ARSCNView(frame: CGRect.zero)
    private weak var _vc: ArNavigationViewController? = nil
}
