//
//  CustomRefreshControl.swift
//  Delicious
//
//  Created by HoaPQ on 8/3/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import RxGesture

class RefreshControl: UIView {

    // MARK: - properties

    //enum for observers
    enum ScrollViewObserver {
        case contentOffset
        case panGesture
    }

    /// indicates refreshing status
    private var refreshingStatus = false

    // MARK: - layers
    private let indicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
        $0.style = .medium
        $0.color = .white
    }

    // MARK: - points on path of border

    ///content offset of scroll view that  keeps updated according to scroll detected
    private var scrollViewContentYOffset: CGFloat = 0

    ///dynamic xposition of panGesture over scroll view
    private var xPositionOfPan: CGFloat = 0

    /// y offset for middle bottom point
    private var middleBottomPointYOffset: CGFloat = 0

    /// center point for circle
    private var centerForCircle: CGPoint = CGPoint(x: 0, y: 0)

    ///threshold drag value
    private var thresholdDrag: CGFloat = 130

    ///maximum height of refresh control
    private var maxHeightOfRefreshControl: CGFloat = 170

    ///called when user refresh is triggered
    private var _onRefreshing: () -> Void = {
        debugPrint("refresh triggerd. Implement setOnRefreshing of RefreshControl to call your own function.")
    }
    
    private var initialInset: CGFloat = 0

    // MARK: - set
    ///set maxHeight of refreshControl. minimum is 130
    var setMaxHeightOfRefreshControl: CGFloat = 0 {
        didSet {
            maxHeightOfRefreshControl = max(setMaxHeightOfRefreshControl, 170)
        }
    }

    //set function to be called after refresh is triggerd
    var onRefreshing: () -> Void = { } {
        didSet {
            _onRefreshing = onRefreshing
        }
    }

    var scrollView: UIScrollView? {
        didSet {
            guard let scrollView = scrollView else { return }
            initialInset = scrollView.contentInset.top
            addObserver(.contentOffset)
            addObserver(.panGesture)
        }
    }
    
    private var containerScrollView: UIScrollView? {
        return scrollView != nil ? scrollView : superview as? UIScrollView
    }
    
    // Rx
    var isRefreshing: Binder<Bool> {
        return Binder(self) { (view, loading) in
            if !loading {
                view.endRefreshing()
            }
        }
    }
    
    private let _refreshTrigger = PublishSubject<Void>()
    
    var refreshTrigger: Driver<Void> {
        return _refreshTrigger.asDriver(onErrorJustReturn: ())
    }

    // MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addObserver(.contentOffset)
        addObserver(.panGesture)
    }

    // MARK: - common init
    private func commonInit() {
        addSubview(indicator)
    }

    // MARK: - draw rect
    override func draw(_ rect: CGRect) {

        guard let _ = containerScrollView else { return }
        calculateIndicatorFrame(rect)

        if !refreshingStatus {
            indicator.startAnimating()
        }
    }

    // MARK: - observers

    private func addObserver(_ observer: ScrollViewObserver) {
        guard let scrollView = containerScrollView else { return }

        switch observer {
        case .contentOffset:
            scrollView.rx.contentOffset
                .asDriver()
                .do(onNext: { [weak self] offset in
                    self?.scrollViewContentYOffset = -offset.y
                    self?.setNeedsDisplay()
                })
                .drive()
                .disposed(by: rx.disposeBag)

        case .panGesture:
            scrollView.rx.panGesture().when(.cancelled, .failed, .ended)
                .asDriverOnErrorJustComplete()
                .do(onNext: { [weak self] panGesture in
                    guard let `self` = self else { return }
                    self.xPositionOfPan = panGesture.location(in: self.containerScrollView).x
                    self.setNeedsDisplay()
                    if self.scrollViewContentYOffset > self.thresholdDrag {
                        self.refreshingStatus = true
                        self.setNeedsDisplay()
                        self.indicator.startAnimating()
                        self._onRefreshing()
                        self._refreshTrigger.onNext(())
                    }
                })
                .drive()
                .disposed(by: rx.disposeBag)
        }
    }

    // MARK: - calculation
    private func calculateIndicatorFrame(_ rect: CGRect) {
        guard scrollViewContentYOffset >= 0 else {
            middleBottomPointYOffset = initialInset
            return
        }
        if !refreshingStatus {
            middleBottomPointYOffset = min(scrollViewContentYOffset, maxHeightOfRefreshControl) - 20 - initialInset
        } else {
            middleBottomPointYOffset = min(scrollViewContentYOffset, thresholdDrag)
        }
        centerForCircle = CGPoint(x: rect.midX, y: middleBottomPointYOffset)
        indicator.frame = CGRect(origin: centerForCircle, size: .zero)
    }

    func endRefreshing() {
        indicator.stopAnimating()
        refreshingStatus = false
    }
}
