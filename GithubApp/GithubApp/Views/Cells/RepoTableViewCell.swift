//
//  RepoTableViewCell.swift
//  GithubApp
//
//  Created by VenD-Omeir on 09/10/2021.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: CustomImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var languageColorView: UIView!
    
    @IBOutlet weak var languageStackView: UIStackView!
    
    @IBOutlet weak var starImageView: UIImageView!
    
    var theme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 35
        languageColorView.clipsToBounds = true
        languageColorView.layer.cornerRadius = 10
    }
    
    func configureCell(repositoryViewModel: RepositoryViewModel) {
        titleLabel.text = repositoryViewModel.title
        subtitleLabel.text = repositoryViewModel.subtitle
        descriptionLabel.text = repositoryViewModel.description
        languageLabel.text = repositoryViewModel.language
        languageStackView.isHidden = repositoryViewModel.language.isEmpty
        countLabel.text = repositoryViewModel.stars
        profileImageView.loadImageWithUrlString(url: repositoryViewModel.imageURL)
        starImageView.image = theme == .dark ? UIImage(named: repositoryViewModel.darkModeStarImage) : UIImage(named: repositoryViewModel.lightModeStarImage)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        starImageView.image = traitCollection.userInterfaceStyle == .dark ? UIImage(named: "white_star") : UIImage(named: "star")
    }
    
}
