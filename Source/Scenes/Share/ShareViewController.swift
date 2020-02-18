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
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK:- Setup
    
    private func setup() {
        view.backgroundColor = .base1
        addDescriptionContainer()
        addTitle()
        addSubtitle()
        addSelectPhotoButton()
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
    
    // MARK: - Actions
    
    @objc func didTapSelectPhotoButton() {
        
    }
}
