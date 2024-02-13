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
    
    
    
    public func makeNewImage(point: CGPoint, imageView: UIImageView) -> UIImage? {
        guard let image = imageView.image else { return nil }
        let pointInImageCoordinates = convertPointToImageCoordinates(point: point, imageSize: image.size, imageViewSize: imageView.bounds.size)

        if let newImage = image.applyingFloodFill(from: pointInImageCoordinates, fillColor: selectedColor.buttonColor) {
            return newImage
        }
        return nil
    }
    
    private func convertPointToImageCoordinates(point: CGPoint, imageSize: CGSize, imageViewSize: CGSize) -> CGPoint {
        let scaleFactorX = imageSize.width / imageViewSize.width
        let scaleFactorY = imageSize.height / imageViewSize.height
        let imagePoint = CGPoint(x: point.x * scaleFactorX, y: point.y * scaleFactorY)
        return imagePoint
    }
    
}
