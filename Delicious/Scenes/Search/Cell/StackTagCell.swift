//
//  StackTagCell.swift
//  Delicious
//
//  Created by HoaPQ on 8/6/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import MaterialComponents

final class StackTagCell: UITableViewCell, Reusable {
    
    private let spacing: CGFloat = 8
    var tapDelete: ((SearchTag) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
    }
    
    func setUp(tags: [SearchTag]) {
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        var hStackView          = UIStackView()
        hStackView.axis         = .horizontal
        hStackView.spacing      = spacing
        hStackView.alignment    = .fill
        hStackView.distribution = .fill

        let vStackView          = UIStackView()
        vStackView.axis         = .vertical
        vStackView.spacing      = spacing
        vStackView.alignment    = .top

        var tagsWidth: CGFloat = 0
        for tag in tags {
            let chip = MDCChipView().then {
                $0.setTitleColor(.white, for: .normal)
                $0.titleFont = UIFont.avenirBookFont(size: 17)
                $0.setBackgroundColor(.systemOrange, for: .normal)
                $0.titleLabel.text = tag.textString
                $0.invalidateIntrinsicContentSize()
                $0.accessoryView = UIImageView(
                    frame: CGRect(origin: .zero,
                                  size: CGSize(width: 10, height: 10))
                ).then {
                    $0.image = Icon.icCancel
                }
                $0.addGestureRecognizer(createTapGesture(with: tag))
            }
            chip.invalidateIntrinsicContentSize()

            if tagsWidth + chip.bounds.width < bounds.width {
                tagsWidth += chip.bounds.width
                hStackView.addArrangedSubview(chip)
            } else {
                vStackView.addArrangedSubview(hStackView)
                tagsWidth = chip.bounds.width
                hStackView = UIStackView()
                hStackView.axis         = .horizontal
                hStackView.spacing      = spacing
                hStackView.alignment    = .fill
                hStackView.distribution = .fill
                hStackView.addArrangedSubview(chip)
            }
        }

        vStackView.addArrangedSubview(hStackView)
        contentView.addSubview(vStackView)
        vStackView.snp.makeConstraints {
            $0.centerY.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(spacing * 2)
            $0.top.equalToSuperview().offset(spacing)
        }
    }
    
    private func createTapGesture(with tag: SearchTag) -> SearchTagTapRecognizer {
        return SearchTagTapRecognizer(target: self, action: #selector(tap(sender:))).then {
            $0.searchTag = tag
        }
    }
    
    @objc private func tap(sender: SearchTagTapRecognizer) {
        guard let tag = sender.searchTag else { return }
        tapDelete?(tag)
    }
}

final class SearchTagTapRecognizer: UITapGestureRecognizer {
    var searchTag: SearchTag?
}
