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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    let animationFileName: String
    
    let onButtonPress: () -> ()
    
    fileprivate func hookButtonAction() {
        actionButton.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
    }
    
    init(animationFileName: String, buttonTitle: String, title: String, subtitle:String, onButtonPress: @escaping () -> ()) {
        self.animationFileName = animationFileName
        self.onButtonPress = onButtonPress
        super.init(frame: .zero)
        setupAnimationView(animationFileName, buttonTitle)
        hookButtonAction()
        setupTitleLabel(title)
        setupSubtitleLabel(subtitle)
        setupActionButton()
    }
    
    @objc func handleButtonTap() {
        onButtonPress()
    }
    
    fileprivate func setupAnimationView(_ animationFileName: String, _ buttonTitle: String) {
        animatedView.animation = Animation.named(animationFileName)
        self.addSubview(animatedView)
        animatedView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        animatedView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        animatedView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        animatedView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
        actionButton.setupStyle(title: buttonTitle)
        animatedView.play()
    }
    
    fileprivate func setupTitleLabel(_ title: String) {
        self.addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.topAnchor.constraint(equalTo: animatedView.bottomAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    fileprivate func setupSubtitleLabel(_ subtitle: String) {
        self.addSubview(subtitleLabel)
        subtitleLabel.text = subtitle
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    fileprivate func setupActionButton() {
        self.addSubview(actionButton)
        actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 15).isActive = true
        actionButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        actionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
