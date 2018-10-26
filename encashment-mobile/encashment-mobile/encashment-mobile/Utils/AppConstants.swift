import UIKit
import Foundation

/// Class keeping application UI constants.
class AppConstants
{
    // MARK: - Public static constants
    
    static let ICON_WIDTH: CGFloat = 44.0
    static let ICON_HEIGHT: CGFloat = 44.0
    static let TOOLBAR_HEIGHT: CGFloat = 44.0
    static let STANDARD_OFFSET: CGFloat = 8.0
    
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    static let STANDARD_GRAY_COLOR: UIColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
    
    static let WAIT_MESSAGE = "Пожалуйста, подождите..."
    static let ERROR_VIEW_TITLE = "Ошибка"
    static let ERROR_OK = "OK"
}
