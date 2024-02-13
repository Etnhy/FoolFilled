//
//  ColorsType.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import UIKit

enum ColorsType: Int, CaseIterable {
    case red,yellow,blue,brown
    
    
    var buttonColor: UIColor {
        switch self {
        case .red: return UIColor.red
        case .yellow: return UIColor.yellow
        case .blue: return UIColor.blue
        case .brown: return UIColor.brown
        }
    }
    var title: String {
        switch self {
        case .red: return "red"
        case .yellow: return "yellow"
        case .blue: return "blue"
        case .brown: return "brown"
        }
    }
}
