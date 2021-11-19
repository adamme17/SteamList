//
//  CustomCell.swift
//  SteamList
//
//  Created by Adam Bokun on 17.11.21.
//

import UIKit

class CustomCell: UITableViewCell {
    var safeArea: UILayoutGuide!
    var imageIV = UIImageView()
    let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    func setupView() {
        safeArea = layoutMarginsGuide
        setupImageView()
        setupNameLabel()
    }
    
    func setupImageView() {
        addSubview(imageIV)

        imageIV.translatesAutoresizingMaskIntoConstraints = false
        imageIV.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        imageIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageIV.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageIV.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //imageIV.backgroundColor = .red
    }
    
    func setupNameLabel() {
        addSubview(nameLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        imageIV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        imageIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        nameLabel.font = UIFont(name: "Verdana-Bold", size: 16)
    }
}

