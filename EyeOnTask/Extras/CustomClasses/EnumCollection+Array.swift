//
//  Enum+Array.swift
//  EyeOnTask
//
//  Created by Hemant Pandagre on 12/07/18.
//  Copyright © 2018 Hemant. All rights reserved.
//

import Foundation


public protocol CaseIterable {
    associatedtype cases: Collection where cases.Element == Self
    static var allCases: cases { get }
}
extension CaseIterable where Self: Hashable {
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}
