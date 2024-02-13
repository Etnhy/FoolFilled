//
//  ViewController.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var mainView = DrawView()

    override func loadView() {
        super.loadView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }



}

