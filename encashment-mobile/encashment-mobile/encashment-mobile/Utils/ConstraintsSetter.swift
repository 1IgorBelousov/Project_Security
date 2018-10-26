import Foundation
import UIKit

class ConstraintsSetter
{
    // MARK: - Public static methods
    
    static func SetConstraints(viewsDictionary: [String:Any], metricsDictionary: [String: CGFloat]?, constraintsDictionary: [String: [String: NSLayoutFormatOptions]])
    {
        for (viewKey, viewConstraints) in constraintsDictionary
        {
            if let targetView: UIView = viewsDictionary[viewKey] as? UIView
            {
                for (constraintDescription, constraintOption) in viewConstraints
                {
                    targetView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraintDescription, options: constraintOption, metrics: metricsDictionary, views: viewsDictionary))
                }
            }
        }
    }
}
