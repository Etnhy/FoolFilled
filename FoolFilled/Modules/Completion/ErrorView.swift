//
//  ErrorView.swift
//  FoolFilled
//
//  Created by evhn on 13.02.2024.
//

import UIKit
 let screenSize = UIScreen.main.bounds


final class ErrorView {
    static let shared = ErrorView()
    
    private var container = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
    private var blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var completeTextLabel = UILabel(frame: CGRect(x: screenSize.width / 2 - (screenSize.width - 160) / 2,
                                                          y: screenSize.height / 2 - screenSize.height / 10,
                                                          width: screenSize.width - 160, height: 50))

    init() {
        completeTextLabel.backgroundColor = .white
        completeTextLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        completeTextLabel.textAlignment = .center
        completeTextLabel.textColor = .black
        container.backgroundColor = UIColor.clear
        

        blurEffect.frame = container.bounds
        blurEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    }
    private func setupText(text: String) {
        completeTextLabel.text = text
    }


    
    func showWithBlurEffect(completeStyle: String) {
        setupText(text: completeStyle)
        container.frame = CGRect.init(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        if !UIAccessibility.isReduceTransparencyEnabled {
            container.backgroundColor = UIColor.clear
            container.addSubview(blurEffect)
            container.addSubview(completeTextLabel)
        } else {
            container.backgroundColor = UIColor.white.withAlphaComponent(0.98)
        }
        if let window = getKeyWindow() {
            window.addSubview(container)
        }
        container.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.container.alpha = 1.0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.hide()
        }
    }
    
    private func show() -> Void {
        container.frame = CGRect.init(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        container.backgroundColor = UIColor.black.withAlphaComponent(0.80)
        if let window = getKeyWindow() {
            window.addSubview(container)
        }
        container.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.container.alpha = 1.0
        })
    }
    private func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.container.alpha = 0.0
        }) { finished in
            self.completeTextLabel.removeFromSuperview()
            self.blurEffect.removeFromSuperview()
            self.container.removeFromSuperview()
        }
    }
    private func getKeyWindow() -> UIWindow? {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return window
    }

}
