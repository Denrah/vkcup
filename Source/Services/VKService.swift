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
        VK.sessions.default.logIn(onSuccess: { _ in
            onSuccess?()
        }, onError: { error in
            onError?(error)
        })
    }
}

extension VKService: SwiftyVKDelegate {
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return [.wall]
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let rootViewController = keyWindow?.rootViewController {
          rootViewController.present(viewController, animated: true)
        }
    }
}
