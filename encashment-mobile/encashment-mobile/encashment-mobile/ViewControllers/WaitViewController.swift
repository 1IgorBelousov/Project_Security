import UIKit

/// View controller appearing on waiting.
class WaitViewController: UIViewController
{
    init()
    {
        super.init(nibName: nil, bundle: nil)
        
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setMessage(message: String)
    {
        _labelMessage.text = message
    }
    
    func startWaiting()
    {
        _activityIndicator.startAnimating()
    }
    
    func stopWaiting()
    {
        _activityIndicator.stopAnimating()
    }
    
    // MARK: - Private methods
    
    /// Inits UI for wait view.
    private func _init()
    {
        view.backgroundColor = UIColor.clear
        
        let backgroundRect = UIView()
        backgroundRect.translatesAutoresizingMaskIntoConstraints = false
        backgroundRect.backgroundColor = UIColor.clear //UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
        view.addSubview(backgroundRect)
        
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        _activityIndicator.startAnimating()
        view.addSubview(_activityIndicator)
        
        _labelMessage.translatesAutoresizingMaskIntoConstraints = false
        _labelMessage.textColor = UIColor.blue
        _labelMessage.lineBreakMode = .byWordWrapping
        _labelMessage.numberOfLines = 3
        _labelMessage.textAlignment = .center
        view.addSubview(_labelMessage)
        
        let views: [String: UIView] =
        [
            "main": self.view,
            "acInd": _activityIndicator,
            "lblMsg": _labelMessage,
            "bkgdRect": backgroundRect
        ]
        
        let metrics: [String: CGFloat] =
        [
            "indWidth": 29.0,
            "indHeight": 29.0,
            "lblWidth": 250.0,
            "lblHeight": 29.0,
            "bkgdWidth": 300,
            "bkgdHeight": 300
        ]
        
        let constraints =
        [
            "main":
            [
                "H:[main]-(<=1)-[acInd(indWidth)]": NSLayoutFormatOptions.alignAllCenterY,
                "V:[main]-(<=1)-[acInd(indHeight)]": NSLayoutFormatOptions.alignAllCenterX,
                "H:[lblMsg(lblWidth)]": NSLayoutFormatOptions(rawValue: 0),
                "V:[main]-(<=1)-[lblMsg(lblHeight)]": NSLayoutFormatOptions.alignAllCenterX,
                "V:[acInd]-[lblMsg]": NSLayoutFormatOptions(rawValue: 0),
                "H:[main]-(<=1)-[bkgdRect(bkgdWidth)]": NSLayoutFormatOptions.alignAllCenterY,
                "V:[main]-(<=1)-[bkgdRect(bkgdHeight)]": NSLayoutFormatOptions.alignAllCenterX
            ]
        ]
        
        ConstraintsSetter.SetConstraints(viewsDictionary: views, metricsDictionary: metrics, constraintsDictionary: constraints)
    }
    
    // MARK: - Private fields.
    
    private let _labelMessage = UILabel()
    private let _activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
}
