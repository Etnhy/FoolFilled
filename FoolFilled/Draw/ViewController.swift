//
//  ViewController.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var mainView:DrawView = {
        var view = DrawView()
        view.delegate = self
        return view
    }()

    private lazy var viewModel: DrawViewModel = {
        var model = DrawViewModel()
        return model
    }()
    
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
}

extension ViewController: DrawViewDelegate {
    func filledImage(point: CGPoint, imageView: UIImageView) {
        let image = viewModel.makeNewImage(point: point, imageView: imageView)
        mainView.remakeImage(image: image)
    }
    
    func cleareImage() {
        mainView.setupImage(imageName: viewModel.clearImage().imageName)
    }

    func selectedColor(color: ColorsType) {
        viewModel.selectedColor = color
    }
    
    
}

