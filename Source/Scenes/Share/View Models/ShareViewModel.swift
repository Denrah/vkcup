//
//  ShareViewModel.swift
//  VKCup
//

import UIKit

protocol ShareViewModelDelegate: class {
  func shareViewModelDidRequestToShowImagePicker(_ viewModel: ShareViewModel)
}

class ShareViewModel {
  weak var delegate: ShareViewModelDelegate?
  
  var onDidSelectImage: ((UIImage) -> Void)?
  
  func showImagePicker() {
    delegate?.shareViewModelDidRequestToShowImagePicker(self)
  }
  
  func didSelectImage(image: UIImage) {
    onDidSelectImage?(image)
  }
}
