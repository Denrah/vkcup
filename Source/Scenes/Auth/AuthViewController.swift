//
//  AuthViewController.swift
//  VKCup
//

import UIKit
import SnapKit

class AuthViewController: BaseViewController {
    // MARK: - Subviews
    
    let loginButton = StandardButton()
    
    // MARK: - Properties
    
    private let viewModel: AuthViewModel
    
    // MARK: - Init
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindToViewModel()
    }
    
    // MARK: - Bind
    
    private func bindToViewModel() {
        viewModel.onDidReceiveError = { [weak self] error in
            self?.handle(error)
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.backgroundColor = .base1
        addLoginButton()
    }
    
    private func addLoginButton() {
        view.addSubview(loginButton)
        
        loginButton.setTitle(NSLocalizedString("login.button.title", comment: "Title of a login button on auth screen"), for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        loginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapLogin() {
        viewModel.login()
    }
}
