//
//  ViewModel.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import UIKit

final class DrawViewModel: BaseViewModel {
    
     var selectedColor: ColorsType = .blue
    
    private(set) var currentImage: UIImage? = nil
    
    func clearImage() -> ImagesType {
        currentImage = UIImage(named: ImagesType.first.imageName)
        return .first
    }
    
    public func shareImage() {
        guard let currentImage = currentImage else { return }
        viewModelDelegate?.showActivity(url: currentImage)
    }
    
    
    public func makeNewImage(point: CGPoint, imageView: UIImageView) async throws ->  UIImage? {
        await viewModelDelegate?.loader(isStart: true)
        guard let image = await imageView.image else { 
            throw ImagesError.imageNotFound
        }
        
        let pointInImageCoordinates = await convertPointToImageCoordinates(point: point, imageSize: image.size, imageViewSize: imageView.bounds.size)

        if let newImage = image.applyingFloodFill(from: pointInImageCoordinates, fillColor: selectedColor.buttonColor) {
            await viewModelDelegate?.loader(isStart: false)
            currentImage = newImage
            return newImage
        }
        
        throw ImagesError.incorrectImage
    }
    
    private func convertPointToImageCoordinates(point: CGPoint, imageSize: CGSize, imageViewSize: CGSize) async -> CGPoint {
        let scaleFactorX = imageSize.width / imageViewSize.width
        let scaleFactorY = imageSize.height / imageViewSize.height
        let imagePoint = CGPoint(x: point.x * scaleFactorX, y: point.y * scaleFactorY)
        return imagePoint
    }
    
}


