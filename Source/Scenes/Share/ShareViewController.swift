//
//  ShareViewController.swift
//  VKCup
//

import UIKit
import SnapKit

class ShareViewController: UIViewController {
  // MARK: - Subviews
  
  private let descriptionContainerView = UIView()
  private let iconImageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let selectPhotoButton = StandardButton()
  private let overlayView = UIView()
  private let activityIndicator = UIActivityIndicatorView(style: .gray)
  private let bottomSheetGapView = UIView()
  private let bottomSheet: SharingBottomSheet
  
  private var bottomSheetBottomConstraint: Constraint?
  
  // MARK: - Properties
  
  private let viewModel: ShareViewModel
  
  private var isBottomSheetOpened = false
  private var bottomSheetFrameObserver: NSKeyValueObservation?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification, object: nil)
    setup()
  }
  
  // MARK: - Init
  
  init(viewModel: ShareViewModel) {
    self.viewModel = viewModel
    bottomSheet = SharingBottomSheet(viewModel: viewModel.sharingBottomSheetViewModel)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK:- Setup
  
  private func setup() {
    view.backgroundColor = .base1
    addDescriptionContainer()
    addIcon()
    addTitle()
    addSubtitle()
    addSelectPhotoButton()
    addBottomSheet()
    bindToViewModel()
    addActivityIndicator()
  }
  
  private func addDescriptionContainer() {
    view.addSubview(descriptionContainerView)
    
    descriptionContainerView.snp.makeConstraints { make in
      make.height.equalTo(296)
      make.leading.trailing.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
  
  private func addIcon() {
    descriptionContainerView.addSubview(iconImageView)
    
    iconImageView.tintColor = .shade4
    iconImageView.image = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
    iconImageView.contentMode = .scaleAspectFit
    
    iconImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(48)
      make.centerX.equalToSuperview()
      make.width.height.equalTo(56)
    }
  }
  
  private func addTitle() {
    descriptionContainerView.addSubview(titleLabel)
    
    titleLabel.textColor = .base2
    titleLabel.textAlignment = .center
    titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
    titleLabel.text = NSLocalizedString("title.label.text", comment: "Sharing title")
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(iconImageView.snp.bottom).offset(12)
      make.leading.trailing.equalToSuperview().inset(16)
    }
  }
  
  private func addSubtitle() {
    descriptionContainerView.addSubview(subtitleLabel)
    
    subtitleLabel.textColor = .shade3
    subtitleLabel.textAlignment = .center
    subtitleLabel.numberOfLines = 0
    subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
    subtitleLabel.text = NSLocalizedString("subtitle.label.text", comment: "Sharing subtitle")
    
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview().inset(16)
    }
  }
  
  private func addSelectPhotoButton() {
    descriptionContainerView.addSubview(selectPhotoButton)
    
    selectPhotoButton.setTitle(NSLocalizedString("select.photo.button.title", comment: "Select photo button title"),
                               for: .normal)
    selectPhotoButton.addTarget(self, action: #selector(didTapSelectPhotoButton), for: .touchUpInside)
    
    selectPhotoButton.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
      make.height.equalTo(36)
      make.centerX.equalToSuperview()
    }
  }
  
  private func addBottomSheet() {
    view.addSubview(overlayView)
    view.addSubview(bottomSheet)
    view.addSubview(bottomSheetGapView)
    
    overlayView.backgroundColor = UIColor.base2.withAlphaComponent(0)
    overlayView.isHidden = true
    overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeBottomSheet)))
    
    bottomSheetFrameObserver = bottomSheet.observe(\.center, options: .new) { [weak self] bottomSheet, _ in
      guard let self = self else { return }
      
      var topInset: CGFloat = 0
      
      if #available(iOS 11.0, *) {
        topInset = self.view.safeAreaInsets.top
      }
      
      if topInset == bottomSheet.frame.origin.y {
        self.viewModel.lockBottomSheetCommentTextView()
      }
    }
    
    bottomSheetGapView.backgroundColor = .base1
    
    overlayView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    bottomSheet.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.snp.bottom)
    }
    
    bottomSheetGapView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(bottomSheet.snp.bottom)
      make.height.equalTo(UIScreen.main.bounds.height)
    }
  }
  
  private func addActivityIndicator() {
    view.addSubview(activityIndicator)
    
    activityIndicator.isHidden = true
    
    activityIndicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
  
  // MARK: - Bind
  
  private func bindToViewModel() {
    viewModel.onDidSelectImage = { [weak self] image in
      self?.showBottomSheet()
    }
    
    viewModel.onDidRequestToCloseBottomSheet = { [weak self] in
      self?.hideBottomSheet()
    }
    
    viewModel.onDidReceiveError = { [weak self] error in
      let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("common.close", comment: "Close button title"),
                                    style: .cancel, handler: nil))
      self?.present(alert, animated: true, completion: nil)
    }
    
    viewModel.onDidPostPhoto = { [weak self] in
      let alert = UIAlertController(title: nil,
                                    message: NSLocalizedString("photo.was.sent.alert.text", comment: "Photo was sent alert text"),
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("common.close", comment: "Close button title"),
                                    style: .cancel, handler: nil))
      self?.present(alert, animated: true, completion: nil)
    }
    
    viewModel.onDidStartRequest = { [weak self] in
      self?.activityIndicator.isHidden = false
      self?.activityIndicator.startAnimating()
      self?.descriptionContainerView.isHidden = true
    }
    
    viewModel.onDidFinishRequest = { [weak self] in
      self?.activityIndicator.isHidden = true
      self?.activityIndicator.stopAnimating()
      self?.descriptionContainerView.isHidden = false
    }
  }
  
  // MARK: - Actions
  
  @objc private func didTapSelectPhotoButton() {
    viewModel.showImagePicker()
  }
  
  @objc private func closeBottomSheet() {
    hideBottomSheet()
  }
  
  private func showBottomSheet() {
    bottomSheet.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview()
      if #available(iOS 11.0, *) {
        bottomSheetBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
        make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.top)
      } else {
        bottomSheetBottomConstraint = make.bottom.equalToSuperview().constraint
        make.top.greaterThanOrEqualToSuperview()
      }
    }
    
    overlayView.isHidden = false
    
    UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
      self.view.layoutSubviews()
      self.overlayView.backgroundColor = UIColor.base2.withAlphaComponent(0.4)
    }, completion: { _ in
      self.isBottomSheetOpened = true
    })
  }
  
  private func hideBottomSheet() {
    bottomSheet.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.snp.bottom)
    }
    
    UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
      self.view.layoutSubviews()
      self.overlayView.backgroundColor = UIColor.base2.withAlphaComponent(0)
    }, completion: { _ in
      self.overlayView.isHidden = true
      self.isBottomSheetOpened = false
    })
    
    view.endEditing(true)
  }
  
  // MARK: - Keyboard
  
  @objc func keyboardWillShow(notification: Notification) {
      if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]) as? TimeInterval,
        let curve = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]) as? NSNumber {
        if isBottomSheetOpened {
          if #available(iOS 11.0, *) {
            bottomSheetBottomConstraint?.update(offset: -(keyboardSize.height - view.safeAreaInsets.bottom))
          } else {
            bottomSheetBottomConstraint?.update(offset: -keyboardSize.height)
          }
          UIView.animate(withDuration: duration, delay: 0, options: [UIView.AnimationOptions(rawValue: UInt(curve.intValue))],
                         animations: {
            self.view.layoutSubviews()
          }, completion: nil)
        }
      }

  }

  @objc func keyboardWillHide(notification: Notification) {
      if let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]) as? TimeInterval,
      let curve = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]) as? NSNumber {
          if isBottomSheetOpened {
            bottomSheetBottomConstraint?.update(offset: 0)
            UIView.animate(withDuration: duration, delay: 0, options: [UIView.AnimationOptions(rawValue: UInt(curve.intValue))],
                           animations: {
              self.view.layoutSubviews()
            }, completion: nil)
          }
      }
  }
}
