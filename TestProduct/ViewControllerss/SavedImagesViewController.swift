//
//  SavedImagesViewController.swift
//  TestProduct
//
//  Created by Sudeepa Pal on 10/11/24.
//

import UIKit
import RealmSwift

class SavedImagesViewController: UIViewController, UITableViewDataSource {
    
    
    private var savedImages = [SelectedImage]()
    
    let realm = try! Realm()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray
        tableView.register(SavedImgListTableViewCell.self, forCellReuseIdentifier: "imageList")
        return tableView
    }()
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        savedImages = realm.objects(SelectedImage.self).map({$0})
        title = "Image List"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        setupTableViewConstraints()
    }
    

    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedImages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageList", for: indexPath) as! SavedImgListTableViewCell
        
        //cell.imageClicked.image = UIImage(named: "TestImg")
        cell.imageClicked.image = UIImage(data: savedImages[indexPath.row].imageData)
        cell.setConstraints()
        
        return cell
    }
    
}

// MARK: Delegate Methods
extension SavedImagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("The Details of the Selected Photo", savedImages[indexPath.row])
    }
    
}
