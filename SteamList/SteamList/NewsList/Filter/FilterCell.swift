//
//  FilterCell.swift
//  SteamList
//
//  Created by Adam Bokun on 18.01.22.
//

import UIKit

class FilterCell: UITableViewCell {

    static let identifier = "FilterTableViewCell"

    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()

    var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = UIColor(rgb: 0x0476FE)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        self.addSubview(titleLabel)
        self.addSubview(checkmarkImageView)

        titleLabel.snp.makeConstraints { constraints in
            constraints.top.equalToSuperview().offset(10)
            constraints.leading.equalToSuperview().offset(15)
            constraints.bottom.equalToSuperview().offset(-10)
        }

        checkmarkImageView.snp.makeConstraints { constraints in
            constraints.width.equalTo(titleLabel.snp.width).multipliedBy(0.1)
            constraints.height.equalTo(checkmarkImageView.snp.width).multipliedBy(0.8)
            constraints.centerY.equalToSuperview()
            constraints.trailing.equalToSuperview().offset(-10)
            constraints.leading.equalTo(titleLabel.snp.trailing).offset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
