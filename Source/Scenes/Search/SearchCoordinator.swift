//
//  SearchCoordinator.swift
//  VKCup
//

import UIKit

class SearchCoordinator: BaseCoordinator {
  var childCoordinators: [BaseCoordinator] = []
  var onDidFinish: (() -> Void)?
  
  private let navigationController: UINavigationController
  private let appDependency: AppDependency
  
  init(navigationController: UINavigationController, appDependency: AppDependency) {
    self.navigationController = navigationController
    self.appDependency = appDependency
  }
  
  func start() {
    showSearchScreen()
  }
  
  private func showSearchScreen() {
    let viewModel = SearchViewModel(dependencies: appDependency)
    let viewController = SearchViewController(viewModel: viewModel)
    viewController.navigationItem.titleView = viewController.createSelectCityButton()
    navigationController.setNavigationBarHidden(false, animated: true)
    navigationController.navigationBar.barTintColor = .base1
    navigationController.navigationBar.isTranslucent = false
    navigationController.pushViewController(viewController, animated: true)
  }
}
