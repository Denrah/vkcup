//
//  AuthCoordinator.swift
//  VKCup
//


import UIKit

protocol AuthCoordinatorDelegate: class {
  func authCoordinatorDidRequestToShowSearch(_ coordinator: AuthCoordinator)
}

class AuthCoordinator: BaseCoordinator {
  var childCoordinators: [BaseCoordinator] = []
  var onDidFinish: (() -> Void)?
  
  weak var delegate: AuthCoordinatorDelegate?
  
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
  func authViewModelDidRequestToShowSearch(_ viewModel: AuthViewModel) {
    delegate?.authCoordinatorDidRequestToShowSearch(self)
  }
}
