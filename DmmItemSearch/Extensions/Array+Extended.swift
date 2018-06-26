//
//  Array+Extended.swift
//  DmmItemSearch
//
//  Created by cano on 2018/06/21.
//  Copyright © 2018年 sample. All rights reserved.
//

import Foundation

extension Array where Element : Equatable  {

    mutating func remove(_ element: Element) {
        if let index = index(of: element) {
            remove(at: index)
        }
    }

    mutating func replace(_ element: Element) {
        if let index = index(of: element) {
            remove(at: index)
            insert(element, at: index)
        }
    }

    mutating func insertOrUpdate(_ element: Element) {
        if let index = index(of: element) {
            remove(at: index)
            insert(element, at: index)
        } else {
            append(element)
        }
    }
}

extension Array {

    mutating func appendIfPossible(_ element: Element?) {
        guard let e = element else { return }
        self.append(e)
    }


    var lastIndex: Int {
        if self.count == 0 { return 0 }
        return self.count - 1
    }
}
