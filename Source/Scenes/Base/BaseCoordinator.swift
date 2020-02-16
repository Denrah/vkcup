//
//  BaseCoordinator.swift
//  VKCup
//

import UIKit

protocol BaseCoordinator: class {
    var childCoordinators: [BaseCoordinator] { get set }
    var onDidFinish: (() -> Void)? { get set}
    
    func start()
}

extension BaseCoordinator {
    func add(coordinator: BaseCoordinator) {
        childCoordinators.append(coordinator)
        
        onDidFinish = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else { return }
            self?.remove(coordinator: coordinator)
        }
    }
    
    func remove(coordinator: BaseCoordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
