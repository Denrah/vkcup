//
//  ShareCoordinator.swift
//  VKCup
//


import UIKit

class ShareCoordinator: BaseCoordinator {
    var childCoordinators: [BaseCoordinator] = []
    var onDidFinish: (() -> Void)?
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showShareScreen()
    }
    
    private func showShareScreen() {
        let viewController = ShareViewController()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: false)
    }
}
