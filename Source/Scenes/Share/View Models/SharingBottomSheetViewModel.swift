//
//  SharingBottomSheetViewModel.swift
//  VKCup
//

import UIKit

class SharingBottomSheetViewModel {
  private(set) var selectedImage: UIImage
  
  var onDidUpdate: (() -> Void)?
  
  func selectImage(_ image: UIImage) {
    selectedImage = image
    onDidUpdate?()
  }
}
