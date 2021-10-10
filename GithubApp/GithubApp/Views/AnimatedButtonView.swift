//
//  RetryButton.swift
//  GithubApp
//
//  Created by VenD-Omeir on 09/10/2021.
//

import UIKit
import Lottie

class AnimatedButtonView: UIView {
    
    let animatedView : AnimationView = {
        let view = AnimationView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let animationFileName: String
    
    let onButtonPress: () -> ()
    
    init(animationFileName: String, buttonTitle: String, onButtonPress: @escaping () -> ()) {
        self.animationFileName = animationFileName
        self.onButtonPress = onButtonPress
        super.init(frame: .zero)
        animatedView.animation = Animation.named(animationFileName)
        self.addSubview(animatedView)
        animatedView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        animatedView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        animatedView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        animatedView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
        self.addSubview(actionButton)
        actionButton.topAnchor.constraint(equalTo: animatedView.bottomAnchor, constant: 10).isActive = true
        actionButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        actionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        actionButton.setupStyle(title: buttonTitle)
        animatedView.play()
        actionButton.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
    }
    
    @objc func handleButtonTap() {
        onButtonPress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension UIButton {
    
    func setupStyle(title: String) {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.customGreen.cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = .systemBackground
        self.setTitle(title, for: .normal)
        self.setTitleColor(.customGreen, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
}

extension UIColor {
    
    static let customGreen = UIColor(red: 118/225, green: 201/225, blue: 159/225, alpha: 1)
    
}
