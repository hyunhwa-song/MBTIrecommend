//
//  PlaceCell.swift
//  mbtirecommend
//
//  Created by 송현화 on 6/17/25.
//

import UIKit

class PlaceCell: UITableViewCell {
    static let reuseID = "PlaceCell"

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var nameLabel:      UILabel!
    @IBOutlet weak var descLabel:      UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // 카드 스타일 등 필요 시 추가
        placeImageView.layer.cornerRadius = 8
        placeImageView.clipsToBounds      = true
        placeImageView.contentMode        = .scaleAspectFill

        nameLabel.font   = .systemFont(ofSize: 18, weight: .semibold)
        descLabel.font   = .systemFont(ofSize: 14)
        descLabel.textColor = .darkGray
        descLabel.numberOfLines = 0
    }

    func configure(with place: Place) {
        nameLabel.text = place.name
        descLabel.text = place.summary
        // 로컬 asset 이름이거나, URL 로드 라이브러리로 교체 가능
        placeImageView.image = UIImage(named: place.imageURL)
    }
}
