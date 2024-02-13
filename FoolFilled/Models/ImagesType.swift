//
//  ImagesType.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import UIKit


enum ImagesType: Int {
    case first
    
    var imageName: String {
        switch self {
        case .first: return "pic2"
        }
    }
}
