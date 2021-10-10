//
//  RepoTableViewCellExtension.swift
//  GithubApp
//
//  Created by VenD-Omeir on 10/10/2021.
//

import UIKit
import SkeletonView

extension RepoTableViewCell {
   
    func showSkeletonView() {
        profileImageView.showAnimatedGradientSkeleton()
        titleLabel.showAnimatedGradientSkeleton()
        subtitleLabel.showAnimatedGradientSkeleton()
        descriptionLabel.showAnimatedGradientSkeleton()
        languageColorView.showAnimatedGradientSkeleton()
        languageLabel.showAnimatedGradientSkeleton()
        countLabel.showAnimatedGradientSkeleton()
        starImageView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeletonView() {
        profileImageView.hideSkeleton()
        titleLabel.hideSkeleton()
        subtitleLabel.hideSkeleton()
        descriptionLabel.hideSkeleton()
        languageColorView.hideSkeleton()
        languageLabel.hideSkeleton()
        countLabel.hideSkeleton()
        starImageView.hideSkeleton()
    }
}
