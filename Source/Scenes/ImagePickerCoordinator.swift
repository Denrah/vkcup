//
//  ImagePickerCoordinator.swift
//  VKCup
//

import UIKit

protocol ImagePickerCoordinatorDelegate: class {
  func imagePickerCoordinator(_ coordinator: ImagePickerCoordinator, didSelect image: UIImage)
}

class ImagePickerCoordinator: NSObject, BaseCoordinator {
  private let navigationController: UINavigationController
  
  var childCoordinators: [BaseCoordinator] = []
  var onDidFinish: (() -> Void)?
  
  weak var delegate: ImagePickerCoordinatorDelegate?
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    showImagePicker()
  }
  
  private func showImagePicker() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.modalPresentationStyle = .pageSheet
    navigationController.present(picker, animated: true, completion: nil)
  }
}

extension ImagePickerCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    onDidFinish?()
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true) {
      if let image = info[.editedImage] as? UIImage {
        self.delegate?.imagePickerCoordinator(self, didSelect: image)
      }
      self.onDidFinish?()
    }
  }
}
