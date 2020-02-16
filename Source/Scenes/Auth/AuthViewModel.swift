//
//  AuthViewModel.swift
//  VKCup
//

import UIKit
import SwiftyVK

class AuthViewModel {
    typealias Dependencies = HasVKService
    
    // MARK: - Properties
    
    private let dependencies: Dependencies
    
    // MARK: - Closures
    
    var onDidReceiveError: ((Error) -> Void)?
    
    // MARK: - Init
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Actions
    
    func login() {
        dependencies.vkService.login(onSuccess: {
            
        }, onError: { [weak self] error in
            DispatchQueue.main.async {
                self?.onDidReceiveError?(error)
            }
        })
    }
}
