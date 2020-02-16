//
//  AppDelegate.swift
//  VKCup
//

import UIKit
import SwiftyVK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private lazy var mainCoordinator = createMainCoordinator()
    private lazy var appDependency = AppDependency()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        mainCoordinator.start()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let app = options[.sourceApplication] as? String
        VK.handle(url: url, sourceApplication: app)
        return true
    }
    
    func createMainCoordinator() -> MainCoordinator {
        let frame = UIScreen.main.bounds
        let window = UIWindow(frame: frame)
        self.window = window
        return MainCoordinator(window: window, appDependency: appDependency)
    }
}

