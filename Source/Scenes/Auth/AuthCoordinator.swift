//
//  AuthCoordinator.swift
//  VKCup
//


import UIKit

protocol AuthCoordinatorDelegate: class {
  func authCoordinatorDidRequestToShowShareScreen(_ coordinator: AuthCoordinator)
}

class AuthCoordinator: BaseCoordinator {
  weak var delegate: AuthCoordinatorDelegate?
  
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
    viewModel.delegate = self
    let viewController = AuthViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: false)
  }
}

extension AuthCoordinator: AuthViewModelDelegate {
  func authViewModelDidSignIn(_ viewModel: AuthViewModel) {
    delegate?.authCoordinatorDidRequestToShowShareScreen(self)
  }
}
