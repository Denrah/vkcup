//
//  MainCoordinator.swift
//  VKCup
//

import UIKit

class MainCoordinator: BaseCoordinator {
    var childCoordinators: [BaseCoordinator] = []
    var onDidFinish: (() -> Void)?
    
    private let rootNavigationController: UINavigationController
    private let appDependency: AppDependency
    private let window: UIWindow
    
    required init(window: UIWindow, appDependency: AppDependency) {
        self.rootNavigationController = UINavigationController()
        self.window = window
        self.appDependency = appDependency
        window.rootViewController = rootNavigationController
    }
    
    func start() {
        window.makeKeyAndVisible()
        showShareScreen()
    }
    
    func showAuthScreen() {
        let coordinator = AuthCoordinator(navigationController: rootNavigationController,
                                          appDependency: appDependency)
        add(coordinator: coordinator)
        coordinator.start()
    }
    
    func showShareScreen() {
        let coordinator = ShareCoordinator(navigationController: rootNavigationController)
        add(coordinator: coordinator)
        coordinator.start()
    }
}
