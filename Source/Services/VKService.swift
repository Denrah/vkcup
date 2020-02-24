//
//  VKService.swift
//  VKCup
//

import UIKit
import SwiftyVK

class VKService {
  init() {
    setup()
  }
  
  private func setup() {
    VK.setUp(appId: Constants.vkAppID, delegate: self)
  }
}

// MARK: - Public methods

extension VKService {
  func login(onSuccess: (() -> Void)?, onError: ((Error) -> Void)?) {
    VK.sessions.default.logOut()
    VK.sessions.default.logIn(onSuccess: { _ in
      onSuccess?()
    }, onError: { error in
      onError?(error)
    })
  }
  
  func getGroups() {
    VK.API.Groups.search([.q: " ", .market: "true"]).onSuccess { data in
      let response = try JSONSerialization.jsonObject(with: data)
      print(response)
    }.onError { error in
      print(error)
    }.send()
  }
}

extension VKService: SwiftyVKDelegate {
  func vkNeedsScopes(for sessionId: String) -> Scopes {
    return [.groups]
  }
  
  func vkNeedToPresent(viewController: VKViewController) {
    let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
    if let rootViewController = keyWindow?.rootViewController {
      rootViewController.present(viewController, animated: true)
    }
  }
}
