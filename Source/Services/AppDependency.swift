//
//  AppDependency.swift
//  VKCup
//

import UIKit

protocol HasVKService {
    var vkService: VKService { get }
}

class AppDependency: HasVKService {
    let vkService = VKService()
}
