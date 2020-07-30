//
//  UIView+.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

extension UIView {
    var width: CGFloat {
        get { return frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    var height: CGFloat {
        get { return frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }

    var size: CGSize {
        get { return frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }

    var origin: CGPoint {
        get { return frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }

    var centerX: CGFloat {
        get { return center.x }
        set {
            center = CGPoint(x: newValue, y: center.y)
        }
    }

    var centerY: CGFloat {
        get { return center.y }
        set {
            center = CGPoint(x: center.x, y: newValue)
        }
    }

    var top: CGFloat {
        get { return frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var bottom: CGFloat {
        get { return frame.origin.y + frame.size.height }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }

    var right: CGFloat {
        get { return frame.origin.x + frame.size.width }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }

    var left: CGFloat {
        get { return frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
}

// MARK: Corner radius
extension UIView {
    func applyCornerRadius(radius: CGFloat = Constant.cornerRadius) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    func applyRoundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer().then {
            $0.path = path.cgPath
        }
        layer.mask = mask
    }

    func applyCircle() {
        layer.cornerRadius = min(frame.size.height, frame.size.width) * 0.5
        clipsToBounds = true
    }
}

// MARK: Gesture
extension UIView {
    func addTapGesture(target: Any?, action: Selector?) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
    }
}

// MARK: Shadow
extension UIView {
    enum ShadowDirection: Int {
        case top, left, bottom, right
        case topLeft, topRight, bottomLeft, bottomRight
        case all, none
    }

    func applyShadowWithColor(color: UIColor, opacity: Float, radius: CGFloat, offset: CGFloat = 2.0) {
        layer.do {
            $0.shadowColor = color.cgColor
            $0.shadowOpacity = opacity
            $0.shadowOffset = CGSize(width: offset, height: offset)
            $0.shadowRadius = radius
        }
        clipsToBounds = false
    }

    func applyShadowWithColor(color: UIColor, opacity: Float, radius: CGFloat, edge: ShadowDirection, shadowSpace: CGFloat) {

        var sizeOffset = CGSize.zero
        switch edge {
        case .top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)

        case .topLeft:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .topRight:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .bottomLeft:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .bottomRight:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)
            
        case .all:
            sizeOffset = CGSize(width: 0, height: 0)
        case .none:
            sizeOffset = CGSize.zero
        }

        layer.do {
            $0.shadowColor = color.cgColor
            $0.shadowOpacity = opacity
            $0.shadowOffset = sizeOffset
            $0.shadowRadius = radius
        }
        clipsToBounds = false
    }
}

// MARK: Gradient
extension UIView {
    enum GradientDirection {
        case topBottom, bottomTop, leftRight, rightLeft
        case topLeftBottomRight, topRightBottomLeft, bottomLeftTopRight, bottomRightTopLeft
    }

    func addGradientBackground(colors: UIColor..., direction: GradientDirection) {
        clipsToBounds = true
        var cgColors = [CGColor]()
        for color in colors {
            cgColors.append(color.cgColor)
        }
       let gradientLayer = CAGradientLayer().then {
            $0.colors = cgColors
            $0.locations = [0, 1]
            $0.frame = bounds

            switch direction {
            case .topBottom:
                $0.startPoint = CGPoint(x: 0.5, y: 0.0)
                $0.endPoint = CGPoint(x: 0.5, y: 1.0)
            case .bottomTop:
                $0.startPoint = CGPoint(x: 0.5, y: 1.0)
                $0.endPoint = CGPoint(x: 0.5, y: 0.0)
            case .leftRight:
                $0.startPoint = CGPoint(x: 0.0, y: 0.5)
                $0.endPoint = CGPoint(x: 1.0, y: 0.5)
            case .rightLeft:
                $0.startPoint = CGPoint(x: 1.0, y: 0.5)
                $0.endPoint = CGPoint(x: 0.0, y: 0.5)
            case .topLeftBottomRight:
                $0.startPoint = CGPoint(x: 0.0, y: 0.0)
                $0.endPoint = CGPoint(x: 1.0, y: 1.0)
            case .topRightBottomLeft:
                $0.startPoint = CGPoint(x: 1.0, y: 0.0)
                $0.endPoint = CGPoint(x: 0.0, y: 1.0)
            case .bottomLeftTopRight:
                $0.startPoint = CGPoint(x: 0.0, y: 1.0)
                $0.endPoint = CGPoint(x: 1.0, y: 0.0)
            case .bottomRightTopLeft:
                $0.startPoint = CGPoint(x: 1.0, y: 1.0)
                $0.endPoint = CGPoint(x: 0.0, y: 0.0)
            }
        }

        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: Add line
extension UIView {
    enum LinePosition {
        case top
        case bottom
    }

    func addLineToView(position: LinePosition, color: UIColor = UIColor.lightGray, height: Double = 0.3) {
        let lineView = UIView().then {
            $0.backgroundColor = color
            $0.translatesAutoresizingMaskIntoConstraints = false // This is important!
        }
        addSubview(lineView)

        let metrics = ["width": NSNumber(value: height)]
        let views = ["lineView": lineView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))

        switch position {
        case .top:
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))

        case .bottom: addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        }
    }
}

// MARK: Border
extension UIView {
    enum BorderPosition: Int {
        case top, left, bottom, right
    }

    func applyBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    func addBorderWithColor(color: UIColor, edge: BorderPosition, thicknessOfBorder: CGFloat) {
        var rect = CGRect.zero
        switch edge {
        case .top:
            rect = CGRect(x: 0, y: 0, width: width, height: thicknessOfBorder)
        case .left:
            rect = CGRect(x: 0, y: 0, width: thicknessOfBorder, height: width)
        case .bottom:
            rect = CGRect(x: 0, y: height - thicknessOfBorder, width: width, height: thicknessOfBorder)
        case .right:
            rect = CGRect(x: width - thicknessOfBorder, y: 0, width: thicknessOfBorder, height: height)
        }

        let layerBorder = CALayer().then {
            $0.frame = rect
            $0.backgroundColor = color.cgColor
        }
        layer.addSublayer(layerBorder)
    }
}
// MARK: - Rotate
extension UIView {
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * .pi
        transform = transform.rotated(by: radians)
    }
}

extension UIView {
    func removeAllLayer() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
}
