//
//  ImageTableViewCell.swift
//  TestProduct
//
//  Created by Sudeepa Pal on 09/11/24.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    let imageClicked: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
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
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            imageClicked.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageClicked.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            imageClicked.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            imageClicked.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60),
            
            saveButton.topAnchor.constraint(equalTo: imageClicked.bottomAnchor, constant: 5),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            saveButton.widthAnchor.constraint(equalToConstant: 30),
            saveButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}
