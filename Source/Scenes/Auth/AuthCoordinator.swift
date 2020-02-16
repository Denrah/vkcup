//
//  AuthCoordinator.swift
//  VKCup
//


import UIKit

class AuthCoordinator: BaseCoordinator {
    var childCoordinators: [BaseCoordinator] = []
    var onDidFinish: (() -> Void)?
    
    private let navigationController: UINavigationController
    private let appDependency: AppDependency
    
    init(navigationController: UINavigationController, appDependency: AppDependency) {
        self.navigationController = navigationController
        self.appDependency = appDependency
    }
    
    func start() {
        showAuthScreen()
    }
    
    private func showAuthScreen() {
        navigationController.setNavigationBarHidden(true, animated: false)
        let viewModel = AuthViewModel(dependencies: appDependency)
        let viewController = AuthViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
