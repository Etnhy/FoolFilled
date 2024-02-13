//
//  DrawView.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import UIKit

enum Buttons: Int, CaseIterable {
    case red,yellow,blue,brown
    
    
    var buttonColor: UIColor {
        switch self {
        case .red: return UIColor.red
        case .yellow: return UIColor.yellow
        case .blue: return UIColor.blue
        case .brown: return UIColor.brown
        }
    }
}

class DrawView: UIView {

    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(imageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.remakeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    
    private func setupImage() {
        let image = UIImage(named: "pic")
        
        image?.prepareForDisplay { [weak self] preparedImage in
            DispatchQueue.main.async {
                self?.imageView.image = preparedImage
            }
        }
    }
}
