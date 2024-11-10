//
//  SavedImgListTableViewCell.swift
//  TestProduct
//
//  Created by Sudeepa Pal on 10/11/24.
//

import UIKit

class SavedImgListTableViewCell: UITableViewCell {
    
    let imageClicked: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let loadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemOrange
        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setConstraints() {
        contentView.backgroundColor = .systemGray
        contentView.addSubview(imageClicked)
        contentView.addSubview(loadButton)
        
        NSLayoutConstraint.activate([
            imageClicked.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageClicked.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            imageClicked.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            imageClicked.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60),
            
            loadButton.topAnchor.constraint(equalTo: imageClicked.bottomAnchor, constant: 5),
            loadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            loadButton.widthAnchor.constraint(equalToConstant: 50),
            loadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
