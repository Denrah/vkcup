//
//  StandardButton.swift
//  VKCup
//

import UIKit

class StandardButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .softAccent : .accent
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let width = (titleLabel?.intrinsicContentSize.width ?? 0) + 32
        return CGSize(width: width, height: 36)
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .accent
        setTitleColor(.base1, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        layer.cornerRadius = 10
    }
}
