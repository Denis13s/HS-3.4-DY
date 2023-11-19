//
//  Utilities.swift
//  HW-3.2-DY-New
//
//  Created by Denis Yarets on 19/11/2023.
//

import Foundation

struct Utilities {
    static func randomDouble() -> Double {
        return ((Double.random(in: 0...100) * 100) / 100).rounded()
    }
}
