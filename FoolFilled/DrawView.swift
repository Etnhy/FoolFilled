//
//  DrawView.swift
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

class DrawView: UIView {

    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    lazy var colorsButtons: [UIButton] = {
        var buttons: [UIButton] = []
        ColorsType.allCases.forEach { item in
            var button = UIButton(type: .system)
            button.setTitle(item.title, for: .normal)
            button.tag = item.rawValue
            button.backgroundColor = item.buttonColor
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)

            buttons.append(button)
        }
        
        return buttons
    }()
    
    private lazy var buttonStackView: UIStackView = {
        var stack = UIStackView(arrangedSubviews: colorsButtons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 6
        return stack
    }()
    
    private lazy var clearButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setAttributedTitle(NSAttributedString(string: "Clear",attributes: [.foregroundColor: UIColor.black,
                                                                               .font: UIFont.systemFont(ofSize: 18, weight: .bold)]), for: .normal)
        btn.addTarget(self, action: #selector(clearImageView), for: .touchUpInside)
        return btn
        
    }()
    
    private(set) var selectedColor: UIColor = .blue

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [clearButton,imageView,buttonStackView].forEach(addSubview(_:))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)


        setupConstraints()
    }
    
    private func setupConstraints() {

        imageView.snp.remakeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        buttonStackView.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.width.equalTo(imageView)
            make.height.equalTo(70)
            make.centerX.equalTo(imageView)
        }
        clearButton.snp.remakeConstraints { make in
            make.bottom.equalTo(imageView.snp.top).offset(-12)
            make.width.equalTo(120)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    
    private func setupImage() {
        let image = UIImage(named: "pic2")
        
        image?.prepareForDisplay { [weak self] preparedImage in
            DispatchQueue.main.async {
                self?.imageView.image = preparedImage
            }
        }
    }
    
    @objc private func clearImageView() {
        setupImage()
    }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        guard let color = ColorsType(rawValue: sender.tag)?.buttonColor else { return }
        selectedColor = color
    }

    @objc func imageTapped(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let location = gesture.location(in: imageView) // Точка касания в координатах imageView
            guard let image = imageView.image else { return }

            let pointInImageCoordinates = convertPointToImageCoordinates(point: location, imageSize: image.size, imageViewSize: imageView.bounds.size)

            if let newImage = image.applyingFloodFill(from: pointInImageCoordinates, fillColor: selectedColor) {
                imageView.image = newImage
            }
        }
    }
    func convertPointToImageCoordinates(point: CGPoint, imageSize: CGSize, imageViewSize: CGSize) -> CGPoint {
        let scaleFactorX = imageSize.width / imageViewSize.width
        let scaleFactorY = imageSize.height / imageViewSize.height
        let imagePoint = CGPoint(x: point.x * scaleFactorX, y: point.y * scaleFactorY)
        return imagePoint
    }
    

    
    func floodFillImage(_ originalImage: UIImage, fromPoint startPoint: CGPoint, fillColor: UIColor) -> UIImage? {
        guard let inputCGImage = originalImage.cgImage else { return nil }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let width = inputCGImage.width
        let height = inputCGImage.height
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let bytesPerRow = bytesPerPixel * width
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        let context = CGContext(data: &pixelData,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)

        context?.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let outputCGImage = context?.makeImage() else { return nil }
        return UIImage(cgImage: outputCGImage)
    }

}
