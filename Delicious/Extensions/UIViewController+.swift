//
//  UIViewController+.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    func showError(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error",
                                   message: message,
                                   preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertConfirm(title: String?,
                          message: String?,
                          confirmTitle: String = "OK",
                          confirmHandler: (() -> Void)? = nil,
                          cancelTitle: String = "Cancel",
                          cancelHandler: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Custom action
        let btnCancel = UIAlertAction(title: cancelTitle, style: .destructive) { (_) in
            cancelHandler?()
        }
        alert.addAction(btnCancel)
        let btnConfirm = UIAlertAction(title: confirmTitle, style: .default) { (_) in
            confirmHandler?()
        }
        alert.addAction(btnConfirm)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertView(title: String?,
                       message: String?,
                       style: UIAlertController.Style,
                       actions: [(String, UIAlertAction.Style)]) -> Observable<Int> {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: style)
            
            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.0,
                                           style: action.1) { _ in
                                            observer.onNext(index)
                                            observer.onCompleted()
                }
                alertController.addAction(action)
            }
            self.present(alertController,
                         animated: true,
                         completion: nil)
            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
