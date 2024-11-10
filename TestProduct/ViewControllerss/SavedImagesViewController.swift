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
        cell.loadButton.tag = indexPath.row
        cell.loadButton.addTarget(self, action: #selector(uploadImage) , for: .touchUpInside)
        cell.setConstraints()
        
        return cell
    }
    
    
    @objc func uploadImage(_ sender: UIButton) {
        let index = sender.tag
                let imageData = savedImages[index].imageData
                uploadImageOne(imageData, button: sender)
    }
    
    
    func uploadImageOne(_ imageData: Data, button: UIButton) {
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

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(String(describing: error))")
                    return
                }
                print("Upload Response:", String(data: data, encoding: .utf8)!)
                
                // Update the button background image to a checkmark on the main thread
                DispatchQueue.main.async {
                    button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("The Details of the Selected Photo", savedImages[indexPath.row])
    }
    
}
