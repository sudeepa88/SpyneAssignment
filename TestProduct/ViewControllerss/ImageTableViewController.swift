//
//  ImageTableViewController.swift
//  TestProduct
//
//  Created by Sudeepa Pal on 09/11/24.
//

import UIKit
import RealmSwift

class ImageTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var imageCache: NSCache<NSString, UIImage>?
    var imageKeys: [String] = []
    
    private let realm = try! Realm()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "imageCell")
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
    
    override func viewWillAppear(_ animated: Bool) {
        print("View Will Appear is Getting Called")
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell
        
        // Retrieve image from cache using the key
        if let cacheKey = imageKeys[indexPath.row] as NSString?,
           let cachedImage = imageCache?.object(forKey: cacheKey) {
            
            
            cell.imageClicked.image = cachedImage
            cell.saveButton.tag = indexPath.row
            cell.saveButton.addTarget(self, action: #selector(savedInApp), for: .touchUpInside)
            cell.setConstraints()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    @objc func savedInApp(_ sender: UIButton) {
        //sender.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        let index = sender.tag
        let cacheKey = imageKeys[index]
    
        if let cachedImage = imageCache?.object(forKey: cacheKey as NSString),
           let imageData = cachedImage.jpegData(compressionQuality: 0.9) {
            
            let cachedImageObject = SelectedImage()
            cachedImageObject.imageData = imageData
            cachedImageObject.id = cacheKey
            cachedImageObject.isUploaded = false
            
            do {
                try realm.write {
                    print("Adding in to the database")
                    realm.add(cachedImageObject)
                }
                sender.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
            } catch {
                print("Failed to save image in Realm: \(error)")
            }
        }
    }
}
