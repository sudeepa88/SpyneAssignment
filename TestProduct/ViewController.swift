//
//  ViewController.swift
//  TestProduct
//
//  Created by Sudeepa Pal on 09/11/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var photoOutput: AVCapturePhotoOutput?
    var photoPreviewView: UIImageView?
    
    // Accept and Reject buttons
    var acceptButton: UIButton?
    var rejectButton: UIButton?

    // Cache to store the captured photo
    let imageCache = NSCache<NSString, UIImage>()
    
    var imageKeys: [String] = [] // Array to track cache keyss
    
    let tapCameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tap Me", for: .normal)
        button.layer.cornerRadius =  20
        button.backgroundColor = .systemOrange
        button.addTarget(self, action: #selector(openingCamera), for: .touchUpInside)
        return button
    }()
    
    let viewGalleryButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("View Gallery", for: .normal)
            button.layer.cornerRadius = 20
            button.backgroundColor = .systemBlue
            button.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
            return button
        }()

    
    let backButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Back", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemGray
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(dismissCamera), for: .touchUpInside)
            return button
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tapCameraButton)
        view.addSubview(viewGalleryButton)
        setupTapButton()
    }
    
    func setupTapButton() {
        NSLayoutConstraint.activate([
            tapCameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapCameraButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tapCameraButton.widthAnchor.constraint(equalToConstant: 100),
            tapCameraButton.heightAnchor.constraint(equalToConstant: 40),
            
            
            viewGalleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        viewGalleryButton.topAnchor.constraint(equalTo: tapCameraButton.bottomAnchor, constant: 20),
                        viewGalleryButton.widthAnchor.constraint(equalToConstant: 120),
                        viewGalleryButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc func openingCamera() {
        setupCamera()
        setupCaptureButton()
        setupPhotoPreviewView()
        setupActionButtons()
        
        setupBackButton()
    }

    
    @objc func openGallery() {
        print("Open the Gallery")
            let galleryVC = ImageTableViewController()
            galleryVC.imageCache = imageCache // Pass the cache to the new view controller
        
        galleryVC.imageCache = imageCache
                galleryVC.imageKeys = imageKeys // Pass the keys
        
            navigationController?.pushViewController(galleryVC, animated: true)
        }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
            
            photoOutput = AVCapturePhotoOutput()
            if captureSession.canAddOutput(photoOutput!) {
                captureSession.addOutput(photoOutput!)
            }

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            if let videoPreviewLayer = videoPreviewLayer {
                view.layer.addSublayer(videoPreviewLayer)
            }
            
            captureSession.startRunning()
        } catch {
            print("Error setting up camera: \(error)")
        }
    }

    func setupCaptureButton() {
        let captureButton = UIButton()
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.backgroundColor = UIColor.white
        captureButton.layer.cornerRadius = 35
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        view.addSubview(captureButton)
        
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
        ])
    }

    func setupPhotoPreviewView() {
        photoPreviewView = UIImageView()
        photoPreviewView?.translatesAutoresizingMaskIntoConstraints = false
        photoPreviewView?.contentMode = .scaleAspectFit
        photoPreviewView?.isHidden = true
        if let photoPreviewView = photoPreviewView {
            view.addSubview(photoPreviewView)
            NSLayoutConstraint.activate([
                photoPreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                photoPreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                photoPreviewView.topAnchor.constraint(equalTo: view.topAnchor),
                photoPreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
    }
    
    func setupActionButtons() {
        // Accept Button
        acceptButton = UIButton()
        acceptButton?.translatesAutoresizingMaskIntoConstraints = false
        acceptButton?.setTitle("Accept", for: .normal)
        acceptButton?.backgroundColor = UIColor.green
        acceptButton?.layer.cornerRadius = 10
        acceptButton?.isHidden = true
        acceptButton?.addTarget(self, action: #selector(acceptPhoto), for: .touchUpInside)
        
        // Reject Button
        rejectButton = UIButton()
        rejectButton?.translatesAutoresizingMaskIntoConstraints = false
        rejectButton?.setTitle("Reject", for: .normal)
        rejectButton?.backgroundColor = UIColor.red
        rejectButton?.layer.cornerRadius = 10
        rejectButton?.isHidden = true
        rejectButton?.addTarget(self, action: #selector(rejectPhoto), for: .touchUpInside)
        
        if let acceptButton = acceptButton, let rejectButton = rejectButton {
            view.addSubview(acceptButton)
            view.addSubview(rejectButton)
            
            NSLayoutConstraint.activate([
                // Accept Button Constraints
                acceptButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width * 0.25),
                acceptButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
                acceptButton.widthAnchor.constraint(equalToConstant: 100),
                acceptButton.heightAnchor.constraint(equalToConstant: 40),
                
                // Reject Button Constraints
                rejectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width * 0.25),
                rejectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
                rejectButton.widthAnchor.constraint(equalToConstant: 100),
                rejectButton.heightAnchor.constraint(equalToConstant: 40),
            ])
        }
    }

    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    
    func setupBackButton() {
           view.addSubview(backButton)
           NSLayoutConstraint.activate([
               backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
               backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
               backButton.widthAnchor.constraint(equalToConstant: 80),
               backButton.heightAnchor.constraint(equalToConstant: 40)
           ])
       }

       @objc func dismissCamera() {
           // Stop the capture session and remove video preview layer
           print("Dismissing Camera")
           captureSession?.stopRunning()
           videoPreviewLayer?.removeFromSuperlayer()
           
           // Remove other camera-related UI elements
           photoPreviewView?.removeFromSuperview()
           acceptButton?.removeFromSuperview()
           rejectButton?.removeFromSuperview()
           backButton.removeFromSuperview()
       }
    
    
//    @objc func acceptPhoto() {
//        if let capturedImage = photoPreviewView?.image {
//            // Save the captured photo in NSCache
//            imageCache.setObject(capturedImage, forKey: "capturedPhoto")
//            print("Photo accepted and saved to cache")
//        }
//        hidePhotoPreview()
//    }
    
    @objc func acceptPhoto() {
        if let capturedImage = photoPreviewView?.image {
            let uniqueKey = UUID().uuidString // Generate unique key
            imageCache.setObject(capturedImage, forKey: uniqueKey as NSString)
            imageKeys.append(uniqueKey) // Track the key
            print("Photo accepted and saved to cache with key: \(uniqueKey)") // Debug print
        }
        hidePhotoPreview()
    }


    @objc func rejectPhoto() {
        print("Photo rejected")
        hidePhotoPreview()
    }
    
    func hidePhotoPreview() {
        photoPreviewView?.isHidden = true
        acceptButton?.isHidden = true
        rejectButton?.isHidden = true
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error capturing photo: \(error!)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let capturedImage = UIImage(data: imageData) else { return }

        photoPreviewView?.image = capturedImage
        photoPreviewView?.isHidden = false
        acceptButton?.isHidden = false
        rejectButton?.isHidden = false
    }
}
