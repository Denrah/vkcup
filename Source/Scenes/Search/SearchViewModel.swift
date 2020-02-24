//
//  SearchViewModel.swift
//  VKCup
//

import Foundation

class SearchViewModel {
  typealias Dependencies = HasVKService
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    
    dependencies.vkService.getGroups()
  }
}
