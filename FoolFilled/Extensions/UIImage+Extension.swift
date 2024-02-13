//
//  UIImage+Extension.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import Foundation


import UIKit


extension UIImage {
    func applyingFloodFill(from startPoint: CGPoint, fillColor: UIColor) -> UIImage? {
        guard let pixelData = self.pixelData(), let cgImage = self.cgImage else { return nil }
        var modifiedPixelData = pixelData
        guard let targetColor = fillColor.rgba() else { return nil }
        
        let startColor = pixelData[Int(startPoint.y)][Int(startPoint.x)]
        
        floodFill(&modifiedPixelData, x: Int(startPoint.x), y: Int(startPoint.y), startColor: startColor, fillColor: targetColor)
        return createImage(fromPixelData: modifiedPixelData, width: cgImage.width, height: cgImage.height)
    }
    
    private func floodFill(_ pixelData: inout [[(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)]], x: Int, y: Int, startColor: (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8), fillColor: (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)) {
        
        var queue = [(x: Int, y: Int)]()
         queue.append((x, y))
         
         while !queue.isEmpty {
             let point = queue.removeFirst()
             let x = point.x
             let y = point.y
             
             if x < 0 || y < 0 || x >= pixelData[0].count || y >= pixelData.count {
                 continue
             }

             let currentColor = pixelData[y][x]
             if !isColor(currentColor, similarTo: startColor, withTolerance: 100) {
                 continue
             }
             
             pixelData[y][x] = fillColor
             
             queue.append((x + 1, y))
             queue.append((x - 1, y))
             queue.append((x, y + 1))
             queue.append((x, y - 1))
         }
//        var queue = [(x: Int, y: Int)]()
//        queue.append((x, y))
//        
//        while !queue.isEmpty {
//            let point = queue.removeFirst()
//            let x = point.x
//            let y = point.y
//            
//            if x < 0 || y < 0 || x >= pixelData[0].count || y >= pixelData.count || pixelData[y][x] != startColor {
//                continue
//            }
//            
//            pixelData[y][x] = fillColor
//            
//            queue.append((x + 1, y))
//            queue.append((x - 1, y))
//            queue.append((x, y + 1))
//            queue.append((x, y - 1))
//        }
    }
    
    private func createImage(fromPixelData pixelData: [[(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)]], width: Int, height: Int) -> UIImage? {
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let bytesPerRow = bytesPerPixel * width
        var data = pixelData.flatMap { $0 }.flatMap { [$0.red, $0.green, $0.blue, $0.alpha] }
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let providerRef = CGDataProvider(data: Data(bytes: &data, count: data.count * MemoryLayout<UInt8>.size) as CFData) else {
            return nil
        }
        
        guard let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bytesPerPixel * bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: bitmapInfo),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        ) else {
            return nil
        }
        
        return UIImage(cgImage: cgim)
    }
   private func pixelData() -> [[(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)]]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        var pixels = [[(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)]]()
        for y in 0..<Int(size.height) {
            var row = [(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)]()
            for x in 0..<Int(size.width) {
                let offset = (y * Int(size.width) + x) * 4
                row.append((red: pixelData[offset], green: pixelData[offset+1], blue: pixelData[offset+2], alpha: pixelData[offset+3]))
            }
            pixels.append(row)
        }
        
        return pixels
    }
    
    private func isColor(_ color1: (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8), similarTo color2: (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8), withTolerance tolerance: UInt8) -> Bool {
        let isRedSimilar = abs(Int(color1.red) - Int(color2.red)) <= Int(tolerance)
        let isGreenSimilar = abs(Int(color1.green) - Int(color2.green)) <= Int(tolerance)
        let isBlueSimilar = abs(Int(color1.blue) - Int(color2.blue)) <= Int(tolerance)
        let isAlphaSimilar = abs(Int(color1.alpha) - Int(color2.alpha)) <= Int(tolerance)
        return isRedSimilar && isGreenSimilar && isBlueSimilar && isAlphaSimilar
    }

}
