//
//  TextView.swift
//  VKCup
//

import UIKit

class TextView: UITextView {
  init() {
    super.init(frame: CGRect.zero, textContainer: nil)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    backgroundColor = .shade1
    
    layer.borderColor = UIColor.shade2.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 18
    
    font = .systemFont(ofSize: 16)
    contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
  }
}
