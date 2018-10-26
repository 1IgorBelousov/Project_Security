import Foundation
import UIKit

/// Protocol for login VC delegate.
protocol LoginViewControllerDelegate: class
{
    func onLogin(user: String, password: String)
}

/// View controller managing login operations.
class LoginViewController: UIViewController
{
    // MARK: - Public properties
    weak var delegate: LoginViewControllerDelegate? = nil
    
    // MARK: - Public methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view = LoginView(vc: self)
    }
    
    /// Activates when view registered login button click.
    func onLoginButton(login: String?, password: String?)
    {
        if let delegate = delegate
        {
            delegate.onLogin(user: login!, password: password!)
        }
    }
}
