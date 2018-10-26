import UIKit

/// View with login dialog.
class LoginView: UIView
{
    init(vc: LoginViewController)
    {
        super.init(frame: CGRect.zero)
        _vc = vc
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    /// Inits UI.
    private func _init()
    {
        backgroundColor = UIColor.white
        
        let backgroundImage = UIImageView(image: UIImage(named: "login_background"))
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImage)
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.75)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderWidth = 3.0
        containerView.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 235/255.0, alpha: 0.75).cgColor
        addSubview(containerView)
        
        _loginTextField = UITextField()
        _loginTextField.translatesAutoresizingMaskIntoConstraints = false
        _loginTextField.placeholder = LOGIN_PLACEHOLDER
        containerView.addSubview(_loginTextField)
        
        _passwordTextField = UITextField()
        _passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        _passwordTextField.placeholder = PASSWORD_PLACEHOLDER
        _passwordTextField.isSecureTextEntry = true
        containerView.addSubview(_passwordTextField)
        
        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle(BUTTON_LOGIN, for: UIControlState.normal)
        loginButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        loginButton.addTarget(self, action: #selector(self._onLoginButton), for: .touchUpInside)
        containerView.addSubview(loginButton)
        
        let viewsDictionary: [String: Any] =
        [
            "main": self,
            "container": containerView,
            "tfLogin": _loginTextField,
            "tfPassword": _passwordTextField,
            "btnLogin": loginButton,
            "bkgd": backgroundImage
        ]
        
        let metricsDictionary: [String: CGFloat] =
        [
            "borderHorOffset": 50.0,
            "borderVerOffset": 20.0,
            "inputVerOffset": 48.0,
            "lblWidth": 80.0,
            "lblHeight": 48.0,
            "btnWidth": 48.0,
            "btnHeight": 48.0,
            "tfHeight": 48.0
        ]
        
        let constraintsDictionary: [String: [String: NSLayoutFormatOptions]] =
        [
            "main":
            [
                "H:|[bkgd]|": NSLayoutFormatOptions(rawValue: 0),
                "V:|[bkgd]|": NSLayoutFormatOptions(rawValue: 0),
                "H:[main]-(<=1)-[container]": NSLayoutFormatOptions.alignAllCenterY,
                "V:[main]-(<=1)-[container]": NSLayoutFormatOptions.alignAllCenterX,
                "H:|-(>=0)-[container]-(>=0)-|": NSLayoutFormatOptions(rawValue: 0),
                "V:|-(>=0)-[container]-(>=0)-|": NSLayoutFormatOptions(rawValue: 0)
            ],
            "container":
            [
                "H:|-(borderHorOffset)-[tfLogin]-(borderHorOffset)-|": NSLayoutFormatOptions(rawValue: 0),
                "H:|-(borderHorOffset)-[tfPassword]-(borderHorOffset)-|": NSLayoutFormatOptions(rawValue: 0),
                "H:[btnLogin(btnWidth)]": NSLayoutFormatOptions(rawValue: 0),
                "V:|-(borderVerOffset)-[tfLogin(tfHeight)]-[tfPassword(tfHeight)]-[btnLogin(btnHeight)]-(>=0)-|": NSLayoutFormatOptions(rawValue: 0),
                "V:[container]-(<=1)-[btnLogin]": NSLayoutFormatOptions.alignAllCenterX
            ]
        ]
        
        ConstraintsSetter.SetConstraints(viewsDictionary: viewsDictionary, metricsDictionary: metricsDictionary, constraintsDictionary: constraintsDictionary)
    }
    
    /// Login button callback.
    @objc private func _onLoginButton()
    {
        if let vc = _vc
        {
            vc.onLoginButton(login: _loginTextField.text, password: _passwordTextField.text)
        }
    }
    
    // MARK: - Private constants
    
    private let LOGIN_PLACEHOLDER = "Введите логин"
    private let PASSWORD_PLACEHOLDER = "Введите пароль"
    private let BUTTON_LOGIN = "Войти"
    
    private var _loginTextField: UITextField! = nil
    private var _passwordTextField: UITextField! = nil
    
    private var _vc: LoginViewController? = nil
}
