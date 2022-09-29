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
    var sourceName: String { get }
    var date: String? { get }
    var urlToImage: String { get }
}

final class ArticleTableViewCell: UITableViewCell {

    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    var model: ArticleTableViewCellModel? {
        willSet(model) {
            authorLabel.text = model?.author
            titleLabel.text = model?.title
            sourceLabel.text = model?.sourceName
            dateLabel.text = model?.date
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
    
    @IBAction private func didTapFavoriteButton(_ sender: UIButton) {
        
    }
}
