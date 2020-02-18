//
//  SharingBottomSheet.swift
//  VKCup
//

import UIKit

class SharingBottomSheet: UIView {
  // MARK: - Subviews
  
  private let titleLabel = UILabel()
  private let closeButton = UIButton(type: .system)
  private let photoImageView = UIImageView()
  private let commentTextView = TextView()
  private let sendButton = StandardButton(fontSize: 17)
  
  // MARK: - Properties
  
  private let viewModel: SharingBottomSheetViewModel
  
  // MARK: - Init
  
  init(viewModel: SharingBottomSheetViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupContainer()
    setupTitle()
    addTextView()
    setupPhotoImageView()
    setupSendButton()
  }
  
  private func setupContainer() {
    backgroundColor = .base1
    layer.cornerRadius = 14
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  private func setupTitle() {
    addSubview(titleLabel)
    
    titleLabel.textColor = .base2
    titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
    titleLabel.textAlignment = .center
    titleLabel.text = NSLocalizedString("bottom.sheet.title", comment: "Titlo of the bottom sheet")
    
    titleLabel.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview().inset(16)
    }
  }
  
  private func addTextView() {
    addSubview(commentTextView)
    
    commentTextView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(12)
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.height.equalTo(36)
    }
  }
  
  private func setupPhotoImageView() {
    addSubview(photoImageView)
    
    photoImageView.backgroundColor = .red
    photoImageView.clipsToBounds = true
    photoImageView.contentMode = .scaleAspectFill
    photoImageView.layer.cornerRadius = 10
    
    photoImageView.snp.makeConstraints { make in
      make.top.equalTo(commentTextView.snp.bottom).offset(12)
      make.leading.trailing.equalToSuperview().inset(12)
      make.height.equalTo(218)
    }
  }
  
  private func setupSendButton() {
    addSubview(sendButton)
    
    sendButton.setTitle(NSLocalizedString("send.button.title", comment: "Bottom sheet send button title"), for: .normal)
    
    sendButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(12)
      make.top.equalTo(photoImageView.snp.bottom).offset(24)
      make.bottom.equalToSuperview().inset(12)
      make.height.equalTo(44)
    }
  }
}
