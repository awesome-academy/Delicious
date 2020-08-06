//
//  OnboardingView.swift
//  Delicious
//
//  Created by HoaPQ on 8/6/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

final class OnboardingView: UIView, NibOwnerLoadable {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        loadNibContent()
    }
    
    func setUp(_ model: OnboardingModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        contentLabel.text = model.content
    }
}
