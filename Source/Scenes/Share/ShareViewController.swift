//
//  ShareViewController.swift
//  VKCup
//

import UIKit

class ShareViewController: UIViewController {
  // MARK: - Subviews
  
  private let descriptionContainerView = UIView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let selectPhotoButton = StandardButton()
  private let overlayView = UIView()
  private let bottomSheetGapView = UIView()
  private let bottomSheet = SharingBottomSheet()
  
  // MARK: - Properties
  
  private let viewModel: ShareViewModel
  
  private var isBottomSheetOpened = false
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Init
  
  init(viewModel: ShareViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK:- Setup
  
  private func setup() {
    view.backgroundColor = .base1
    addDescriptionContainer()
    addTitle()
    addSubtitle()
    addSelectPhotoButton()
    addBottomSheet()
    bindToViewModel()
  }
  
  private func addDescriptionContainer() {
    view.addSubview(descriptionContainerView)
    
    descriptionContainerView.snp.makeConstraints { make in
      make.height.equalTo(296)
      make.leading.trailing.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
  
  private func addTitle() {
    descriptionContainerView.addSubview(titleLabel)
    
    titleLabel.textColor = .base2
    titleLabel.textAlignment = .center
    titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
    titleLabel.text = NSLocalizedString("title.label.text", comment: "Sharing title")
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(116)
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
  
  // MARK: - Bind
  
  private func bindToViewModel() {
    viewModel.onDidSelectImage = { [weak self] image in
      self?.showBottomSheet()
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
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
  }
}
