//
//  ImageTableViewController.swift
//  TestProduct
//
//  Created by Sudeepa Pal on 09/11/24.
//

import UIKit

class ImageTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var imageCache: NSCache<NSString, UIImage>?
    var imageKeys: [String] = [] // Array to hold cache keys
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "imageCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Recent Captured Images"
        print("Nothing Here")
        view.addSubview(tableView)
        setupTableViewConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
        
        // Retrieve image from cache using the key
        if let cacheKey = imageKeys[indexPath.row] as NSString?,
           let cachedImage = imageCache?.object(forKey: cacheKey) {
            let imageView = UIImageView(image: cachedImage)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            cell.contentView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            ])
        }
        
        return cell
    }
}
