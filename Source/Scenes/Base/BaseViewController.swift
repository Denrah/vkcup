//
//  BaseViewController.swift
//  VKCup
//


import UIKit

class BaseViewController: UIViewController {
    func handle(_ error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("common.close", comment: "Default close button title"),
                                                style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
