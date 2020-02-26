//
//  SharingBottomSheetViewModel.swift
//  VKCup
//

import UIKit

protocol SharingBottomSheetViewModelDelegate: class {
  func sharingBottomSheetViewModelDidRequestToClose(_ viewModel: SharingBottomSheetViewModel)
  func sharingBottomSheetViewModelDidRequestToSendMessage(_ viewModel: SharingBottomSheetViewModel,
                                                          message: String, image: UIImage)
}

class SharingBottomSheetViewModel {
  weak var delegate: SharingBottomSheetViewModelDelegate?
  
  // MARK: - Properties
  
  private(set) var selectedImage: UIImage?
  private(set) var commentText: String?
  private(set) var isCommentTextViewScrollEnabled = false
  
  // MARK: - Closures
  
  var onDidUpdate: (() -> Void)?
  var onDidUpdateCommenetTextViewState: (() -> Void)?
  
  // MARK: - Actions
  
  func selectImage(_ image: UIImage) {
    selectedImage = image
    commentText = nil
    isCommentTextViewScrollEnabled = false
    onDidUpdate?()
  }
  
  func close() {
    delegate?.sharingBottomSheetViewModelDidRequestToClose(self)
  }
  
  func send() {
    guard let image = selectedImage else { return }
    delegate?.sharingBottomSheetViewModelDidRequestToSendMessage(self, message: commentText ?? "", image: image)
    close()
  }
  
  func updateCommentText(text: String?) {
    commentText = text
  }
  
  func lockCommentTextView() {
    isCommentTextViewScrollEnabled = true
    onDidUpdateCommenetTextViewState?()
  }
}
