//
//  UITableView+Rx.swift
//  Delicious
//
//  Created by HoaPQ on 7/22/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

extension Reactive where Base: UITableView {
    var state: Binder<EmptyView.State> {
        return Binder(base) { tableView, state in
            guard let placeHolder = tableView.backgroundView as? EmptyView else { return }
            placeHolder.currentState = state
        }
    }
    
    var action: ControlEvent<Void> {
        guard let placeHolder = base.backgroundView as? EmptyView else { return ControlEvent(events: Observable.of()) }
        return ControlEvent(events: placeHolder.selectTrigger.asObserver())
    }
}
