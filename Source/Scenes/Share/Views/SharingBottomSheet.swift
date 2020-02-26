//
//  SharingBottomSheet.swift
//  VKCup
//

import UIKit

class SharingBottomSheet: UIView {
  // MARK: - Subviews
  
  private let titleLabel = UILabel()
  private let placeholderLabel = UILabel()
  private let closeButton = UIButton(type: .system)
  private let photoImageView = UIImageView()
  private let commentTextView = TextView()
  private let sendButton = StandardButton(fontSize: 17)
  
  // MARK: - Properties
  
  private let viewModel: SharingBottomSheetViewModel
  private var commentTextViewMaxContentHeight: CGFloat?
  private var commentTextViewContentSizeObserver: NSKeyValueObservation?
  
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
    setupCloseButton()
    setupTextView()
    setupPhotoImageView()
    setupSendButton()
    bindToViewModel()
  }
  
  private func setupContainer() {
    backgroundColor = .base1
    layer.cornerRadius = 14
    if #available(iOS 11.0, *) {
      layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    } else {
      var cornerMask = UIRectCorner()
      cornerMask.insert(.topLeft)
      cornerMask.insert(.topRight)
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: cornerMask,
                              cornerRadii: CGSize(width: 14, height: 14))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
    }
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
  
  private func setupCloseButton() {
    addSubview(closeButton)
    
    closeButton.setImage(UIImage(named: "dismiss"), for: .normal)
    closeButton.tintColor = .shade3
    closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    
    closeButton.snp.makeConstraints { make in
      make.top.trailing.equalToSuperview().inset(2)
      make.width.height.equalTo(48)
    }
  }
  
  private func setupTextView() {
    addSubview(commentTextView)
    addSubview(placeholderLabel)
    
    placeholderLabel.font = .systemFont(ofSize: 16, weight: .regular)
    placeholderLabel.textColor = .shade3
    placeholderLabel.text = NSLocalizedString("comment.text.view.placeholder.text", comment: "Comment placeholder")
    
    commentTextView.isScrollEnabled = viewModel.isCommentTextViewScrollEnabled
    commentTextView.delegate = self
    commentTextViewContentSizeObserver = commentTextView.observe(\.contentSize, options: .new) { [weak self] textView, _ in
      guard let maxContentHeight = self?.commentTextViewMaxContentHeight else { return }
      
      if textView.contentSize.height < maxContentHeight {
        textView.isScrollEnabled = false
      }
    }
    
    commentTextView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(12)
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.height.greaterThanOrEqualTo(36)
    }
    
    placeholderLabel.snp.makeConstraints { make in
      make.leading.equalTo(commentTextView.snp.leading).offset(12)
      make.trailing.equalTo(commentTextView.snp.trailing).offset(-12)
      make.top.equalTo(commentTextView.snp.top).offset(8)
    }
  }
  
  private func setupPhotoImageView() {
    addSubview(photoImageView)
    
    photoImageView.backgroundColor = .shade1
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
    sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
    
    sendButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(12)
      make.top.equalTo(photoImageView.snp.bottom).offset(24)
      make.bottom.equalToSuperview().inset(12)
      make.height.equalTo(44)
    }
  }
  
  // MARK: - Bind
  
  private func bindToViewModel() {
    viewModel.onDidUpdate = { [weak self] in
      guard let self = self else { return }
      self.photoImageView.image = self.viewModel.selectedImage
      self.commentTextView.text = self.viewModel.commentText ?? ""
      self.placeholderLabel.isHidden = self.commentTextView.text != ""
      self.commentTextView.invalidateIntrinsicContentSize()
      self.commentTextView.isScrollEnabled = self.viewModel.isCommentTextViewScrollEnabled
    }
    
    viewModel.onDidUpdateCommenetTextViewState = { [weak self] in
      guard let self = self else { return }
      self.commentTextView.isScrollEnabled = self.viewModel.isCommentTextViewScrollEnabled
      
      if self.viewModel.isCommentTextViewScrollEnabled {
        self.commentTextViewMaxContentHeight = self.commentTextView.contentSize.height
      }
    }
  }
  
  // MARK: - Actions
  
  @objc private func close() {
    viewModel.close()
  }
  
  @objc private func didTapSend() {
    viewModel.send()
  }
}

extension SharingBottomSheet: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    placeholderLabel.isHidden = textView.text != ""
    viewModel.updateCommentText(text: textView.text)
  }
}
