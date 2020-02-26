//
//  ShareCoordinator.swift
//  VKCup
//


import UIKit

class ShareCoordinator: BaseCoordinator {
  var childCoordinators: [BaseCoordinator] = []
  var onDidFinish: (() -> Void)?
  
  var onDidSelectImage: ((UIImage) -> Void)?
  
  private var navigationController: UINavigationController
  private let appDependency: AppDependency
  
  init(navigationController: UINavigationController, appDependency: AppDependency) {
    self.navigationController = navigationController
    self.appDependency = appDependency
  }
  
  func start() {
    showShareScreen()
  }
  
  private func showShareScreen() {
    let viewModel = ShareViewModel(dependencies: appDependency)
    viewModel.delegate = self
    
    onDidSelectImage = { [weak viewModel] image in
      viewModel?.didSelectImage(image: image)
    }
    
    let viewController = ShareViewController(viewModel: viewModel)
    navigationController.setNavigationBarHidden(true, animated: false)
    navigationController.pushViewController(viewController, animated: true)
  }
  
  private func showImagePicker() {
    let coordinator = ImagePickerCoordinator(navigationController: navigationController)
    coordinator.delegate = self
    add(coordinator: coordinator)
    coordinator.start()
  }
}

extension ShareCoordinator: ShareViewModelDelegate {
  func shareViewModelDidRequestToShowImagePicker(_ viewModel: ShareViewModel) {
    showImagePicker()
  }
}

extension ShareCoordinator: ImagePickerCoordinatorDelegate {
  func imagePickerCoordinator(_ coordinator: ImagePickerCoordinator, didSelect image: UIImage) {
    onDidSelectImage?(image)
  }
}
