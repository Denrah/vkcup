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
  func logOut() {
    VK.sessions.default.logOut()
  }
  
  func login(onSuccess: (() -> Void)?, onError: ((Error) -> Void)?) {
    VK.sessions.default.logIn(onSuccess: { response in
      UserDefaults.standard.setValue(response["user_id"], forKey: "vkUserID")
      onSuccess?()
    }, onError: { error in
      onError?(error)
    })
  }
  
  func postOnWall(message: String, imageID: Int, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
    guard let userID = UserDefaults.standard.value(forKey: "vkUserID") as? String else { return }
    VK.API.Wall.post([.message: message, .attachments: "photo\(userID)_\(imageID)"]).onSuccess { _ in
      onSuccess()
    }.onError { error in
      onError(error)
    }.send()
  }
  
  func uploadFile(imageData: Data, onSuccess: @escaping (Int?) -> Void, onError: @escaping (Error) -> Void) {
    guard let userID = UserDefaults.standard.value(forKey: "vkUserID") as? String else { return }
    VK.API.Upload.Photo.toWall(Media.image(data: imageData, type: .jpg),
                               to: .user(id: userID)).onSuccess { data in
                                let json = try? JSONDecoder().decode([UploadToWallResponse].self, from: data)
                                onSuccess(json?.first?.fileID)
    }.onError { error in
      onError(error)
    }.send()
  }
}

extension VKService: SwiftyVKDelegate {
  func vkNeedsScopes(for sessionId: String) -> Scopes {
    return [.wall, .photos]
  }
  
  func vkNeedToPresent(viewController: VKViewController) {
    let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
    if let rootViewController = keyWindow?.rootViewController {
      rootViewController.present(viewController, animated: true)
    }
  }
}
