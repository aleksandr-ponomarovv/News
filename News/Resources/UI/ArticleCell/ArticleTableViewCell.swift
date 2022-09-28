//
//  ArticleTableViewCell.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import UIKit

protocol ArticleTableViewCellModel {
    var author: String? { get }
    var title: String { get }
    var subtitle: String { get }
    var urlToImage: String { get }
}

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    var model: ArticleTableViewCellModel? {
        willSet(model) {
            authorLabel.text = model?.author
            titleLabel.text = model?.title
            subTitleLabel.text = model?.subtitle
            if let urlString = model?.urlToImage, !urlString.isEmpty {
                iconImageView.downloadImage(urlString: urlString)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        iconImageView.layer.cornerRadius = 3
    }
}
