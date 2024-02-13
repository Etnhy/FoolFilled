//
//  BaseViewModel.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import UIKit

protocol BaseViewModelDelegate: AnyObject {
    func loader(isStart: Bool) async
    func showActivity(url: UIImage)
}
class BaseViewModel {
    weak var viewModelDelegate: BaseViewModelDelegate?
    

    init(viewModelDelegate: BaseViewModelDelegate? = nil) {
        self.viewModelDelegate = viewModelDelegate
    }
}
