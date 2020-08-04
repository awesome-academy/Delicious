//
//  CoreDataError.swift
//  Delicious
//
//  Created by HoaPQ on 8/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

enum CoreDataError: Error {
    case alreadyExist
    
    var message: String {
        switch self {
        case .alreadyExist:
            return "This recipe has already added!"
        }
    }
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
