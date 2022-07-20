//
//  Extensions.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
