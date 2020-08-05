//
//  MagicalRecord+Rx.swift
//  Delicious
//
//  Created by HoaPQ on 8/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import MagicalRecord

extension Reactive where Base: MagicalRecord {
    static func save(block: @escaping (NSManagedObjectContext?) -> Void) -> Observable<Bool> {
        return Observable.create { observer in
            MagicalRecord.save(block, completion: { (changed, error) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(changed)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
    
    static func save(block: @escaping (NSManagedObjectContext?) -> Void) -> Observable<Void> {
        let observable: Observable<Bool> = MagicalRecord.rx.save(block: block)
        return observable.map { _ in () }
    }
}
