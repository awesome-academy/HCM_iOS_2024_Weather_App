//
//  Alerts.swift
//  Weather_App
//
//  Created by ho.bao.an on 26/03/2024.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(title: String, message: String, actionTitle: String = "OK", actionSelectedCompletion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .default, handler: actionSelectedCompletion)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
