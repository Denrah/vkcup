//
//  StandardButton.swift
//  VKCup
//

import UIKit

class StandardButton: UIButton {
  private let fontSize: CGFloat
  
  override var isHighlighted: Bool {
    didSet {
      backgroundColor = isHighlighted ? .softAccent : .accent
    }
  }
  
  override var intrinsicContentSize: CGSize {
    let width = (titleLabel?.intrinsicContentSize.width ?? 0) + 32
    return CGSize(width: width, height: 36)
  }
  
  init(fontSize: CGFloat = 15) {
    self.fontSize = fontSize
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    backgroundColor = .accent
    setTitleColor(.base1, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    layer.cornerRadius = 10
  }
}
