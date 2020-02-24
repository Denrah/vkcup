//
//  AuthViewModel.swift
//  VKCup
//

import UIKit
import SwiftyVK

protocol AuthViewModelDelegate: class {
  func authViewModelDidRequestToShowSearch(_ viewModel: AuthViewModel)
}

class AuthViewModel {
  typealias Dependencies = HasVKService
  
  weak var delegate: AuthViewModelDelegate?
  
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
    dependencies.vkService.login(onSuccess: { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.delegate?.authViewModelDidRequestToShowSearch(self)
      }
    }, onError: { [weak self] error in
      DispatchQueue.main.async {
        self?.onDidReceiveError?(error)
      }
    })
  }
}
