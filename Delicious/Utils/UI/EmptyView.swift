//
//  EmptyView.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

class EmptyView: UIView, NibOwnerLoadable {
    
    enum State {
        case normal
        case empty(String)
        case error(Error)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
    let selectTrigger = PublishSubject<Void>()
    var currentState: State = .normal {
        didSet {
            switch currentState {
            case .normal:
                isHidden = true
            case .empty(let message):
                isHidden = false
                setUp(image: Icon.icEmpty,
                      title: "Opps",
                      message: message,
                      buttonTitle: nil)
            case .error(let error):
                setUp(image: Icon.icError,
                      title: "Opps",
                      message: error.localizedDescription,
                      buttonTitle: "Try again")
            }
        }
    }
    
    private func setUp(image: UIImage?, title: String?, message: String?, buttonTitle: String?) {
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
        actionButton.setTitle(buttonTitle, for: .normal)
        titleLabel.isHidden = title == nil
        messageLabel.isHidden = message == nil
        actionButton.isHidden = buttonTitle == nil
    }
    
    @IBAction private func tapButton(_ sender: Any) {
        selectTrigger.onNext(())
    }
}
