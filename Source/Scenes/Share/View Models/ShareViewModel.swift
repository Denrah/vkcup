//
//  ShareViewModel.swift
//  VKCup
//

import UIKit

protocol ShareViewModelDelegate: class {
  func shareViewModelDidRequestToShowImagePicker(_ viewModel: ShareViewModel)
}

class ShareViewModel {
  typealias Dependencies = HasVKService
  
  weak var delegate: ShareViewModelDelegate?
  
  // MARK: - Propeties
  
  let sharingBottomSheetViewModel: SharingBottomSheetViewModel
  
  private let dependencies: Dependencies
  
  // MARK: - Closures
  
  var onDidSelectImage: ((UIImage) -> Void)?
  var onDidRequestToCloseBottomSheet: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  var onDidPostPhoto: (() -> Void)?
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  
  // MARK: - Init
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
    sharingBottomSheetViewModel = SharingBottomSheetViewModel()
    sharingBottomSheetViewModel.delegate = self
  }
  
  // MARK: - Actions
  
  func showImagePicker() {
    delegate?.shareViewModelDidRequestToShowImagePicker(self)
  }
  
  func didSelectImage(image: UIImage) {
    sharingBottomSheetViewModel.selectImage(image)
    onDidSelectImage?(image)
  }
  
  func lockBottomSheetCommentTextView() {
    sharingBottomSheetViewModel.lockCommentTextView()
  }
}

extension ShareViewModel: SharingBottomSheetViewModelDelegate {
  func sharingBottomSheetViewModelDidRequestToClose(_ viewModel: SharingBottomSheetViewModel) {
    onDidRequestToCloseBottomSheet?()
  }
  
  func sharingBottomSheetViewModelDidRequestToSendMessage(_ viewModel: SharingBottomSheetViewModel,
                                                          message: String, image: UIImage) {
    guard let data = image.jpegData(compressionQuality: 1) else { return }
    self.onDidStartRequest?()
    dependencies.vkService.uploadFile(imageData: data, onSuccess: { [weak self] fileID in
        guard let imageID = fileID else { return }
        self?.dependencies.vkService.postOnWall(message: message, imageID: imageID, onSuccess: {
          DispatchQueue.main.async {
            self?.onDidPostPhoto?()
            self?.onDidFinishRequest?()
          }
        }, onError: { [weak self] error in
          DispatchQueue.main.async {
            self?.onDidReceiveError?(error)
            self?.onDidFinishRequest?()
          }
        })
      }, onError: { [weak self] error in
        DispatchQueue.main.async {
          self?.onDidReceiveError?(error)
          self?.onDidFinishRequest?()
        }
    })
  }
}
