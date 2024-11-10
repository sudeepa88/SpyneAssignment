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
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedImages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageList", for: indexPath) as! SavedImgListTableViewCell
        
        //cell.imageClicked.image = UIImage(named: "TestImg")
        
        if savedImages[indexPath.row].isUploaded == true {
            cell.loadButton.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            cell.loadButton.tintColor = .systemGray2
            cell.loadButton.isUserInteractionEnabled = false
        } else {
            cell.loadButton.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            cell.loadButton.isUserInteractionEnabled = true
            cell.loadButton.tintColor = .systemOrange
        }
        
        
        cell.imageClicked.image = UIImage(data: savedImages[indexPath.row].imageData)
        cell.loadButton.tag = indexPath.row
        cell.loadButton.addTarget(self, action: #selector(uploadImage) , for: .touchUpInside)
        cell.setConstraints()
        
        return cell
    }
    
    
    @objc func uploadImage(_ sender: UIButton) {
        let index = sender.tag
        let imageData = savedImages[index].imageData
        uploadImageOne(imageData, index: index, button: sender)
    }
    
    
    func uploadImageOne(_ imageData: Data, index: Int , button: UIButton) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        
        body += Data("--\(boundary)\r\n".utf8)
        body += Data("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".utf8)
        body += Data("Content-Type: image/jpeg\r\n\r\n".utf8)
        body += imageData
        body += Data("\r\n--\(boundary)--\r\n".utf8)
        
        var request = URLRequest(url: URL(string: "https://www.clippr.ai/api/upload")!, timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = body
        
        
        DispatchQueue.main.async {
            button.setTitle("Uploading", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            button.setTitleColor(.systemGreen, for: .normal)
            button.setBackgroundImage(nil, for: .normal) // Remove the icon while loading
        }
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
            print("Upload Response:", String(data: data, encoding: .utf8)!)
            
            
            DispatchQueue.main.async {
                button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                button.setTitle("", for: .normal)
                button.tintColor = .systemGray2
                button.isUserInteractionEnabled = false
                try? self.realm.write {
                    self.savedImages[index].isUploaded = true
                }
            }
        }
        
        task.resume()
    }
    
}

// MARK: Delegate Methods
extension SavedImagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("The Details of the Selected Photo", savedImages[indexPath.row])
//    }
    
}
