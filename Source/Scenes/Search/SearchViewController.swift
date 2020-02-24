//
//  SearchViewController.swift
//  VKCup
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
  // MARK: - Subviews
  
  private let tableView = UITableView()
  
  // MARK: - Properties
  
  private let viewModel: SearchViewModel
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Init
  
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setup() {
    addTableView()
  }
  
  private func addTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  func createSelectCityButton() -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(NSLocalizedString("title.button.text", comment: "Title text"), for: .normal)
    button.setImage(UIImage.init(named: "dropdown"), for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
    button.tintColor = .base2
    if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
      button.semanticContentAttribute = .forceLeftToRight
    } else {
      button.semanticContentAttribute = .forceRightToLeft
    }
    return button
  }
}
