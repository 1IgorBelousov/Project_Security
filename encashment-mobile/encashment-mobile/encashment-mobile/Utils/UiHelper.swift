import UIKit

class UiHelper
{
    /// Creates flexible toolbar from bar buttons.
    static func MakeToolbar(forItems: [UIBarButtonItem]) -> UIToolbar
    {
        let toolbar = UIToolbar(frame: CGRect.zero)
        
        var toolbarItems: [UIBarButtonItem] = []
        
        for button in forItems
        {
            toolbarItems.append(button)
            toolbarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        // to remove excessive button from the loop above
        _ = toolbarItems.popLast()
        
        toolbar.items = toolbarItems
        
        return toolbar
    }
    
    /// Creates empty button with fixed width for toolbar.
    static func MakeEmptyButton() -> UIBarButtonItem
    {
        let btn = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
        btn.width = AppConstants.ICON_WIDTH
        return btn
    }
}
