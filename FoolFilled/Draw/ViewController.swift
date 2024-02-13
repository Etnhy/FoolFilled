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
        model.viewModelDelegate = self
        return model
    }()
    
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
}

extension ViewController: DrawViewDelegate {
    func shareFilledImage() {
        viewModel.shareImage()
    }
    
    func filledImage(point: CGPoint, imageView: UIImageView) async {
        do {
            let image = try await viewModel.makeNewImage(point: point, imageView: imageView)
            mainView.remakeImage(image: image)

        } catch {
            print(error)
        }
        
    }
    
    func cleareImage() {
        mainView.setupImage(imageName: viewModel.clearImage().imageName)
    }

    func selectedColor(color: ColorsType) {
        viewModel.selectedColor = color
    }
    
    
}

extension ViewController: BaseViewModelDelegate {
    func showActivity(url: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }

        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)

        }
    }
    
    func loader(isStart: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            switch isStart {
            case true: strongSelf.mainView.loader.startAnimating()
            case false: strongSelf.mainView.loader.stopAnimating()
            }
        }
    }
    
    
}
