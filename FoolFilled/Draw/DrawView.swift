//
//  DrawView.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import UIKit

protocol DrawViewDelegate: AnyObject {
    func cleareImage()
    func filledImage(point: CGPoint, imageView: UIImageView)
    func selectedColor(color: ColorsType)
}

class DrawView: UIView {
    
    weak var delegate: DrawViewDelegate?
    
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
        setupImage(imageName: "pic2")
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
    
    

    
     //MARK: -  public
    public func remakeImage(image: UIImage?) {
        guard let image = image else { return}
        self.imageView.image = image
    }
    
    public func setupImage(imageName: String) {
        let image = UIImage(named: imageName)
        
        image?.prepareForDisplay { [weak self] preparedImage in
            DispatchQueue.main.async {
                self?.imageView.image = preparedImage
            }
        }
    }
    
     //MARK: -  ACtions
    
    @objc private func clearImageView() {
        delegate?.cleareImage()
    }
    
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        guard let color = ColorsType(rawValue: sender.tag) else { return }
        selectedColor = color.buttonColor
        delegate?.selectedColor(color: color)

    }

    @objc func imageTapped(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let location = gesture.location(in: imageView) 
            delegate?.filledImage(point: location, imageView: imageView)
        }
    }
    
    


}
