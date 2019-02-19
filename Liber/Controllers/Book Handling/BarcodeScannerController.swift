//
//  BarcodeScannerController.swift
//  Liber
//
//  Created by Jack Bishop on 03/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class holds the logic for the Add View Controller, which is used to add a new entry to the bookcase.

import UIKit
import AVFoundation
import GoogleBooksApiClient
import Firebase

var currentBookData = Book()
var lastBookTitle: String = ""
var sentBookTitle: String = ""
var isFirstRequest: Bool? // Setting first scan request.

class BarcodeScannerController: UIViewController {
    
    // Linking UI Elements
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var blockView: UIView!
    
    // Instance Variables
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var barcodeFrameView: UIView?
    var bookFound : Bool?
    
    // Listing supported datatypes for the barcode, at the current just two the two ISBN standards.
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,]
    
    // MARK: - Setting up BarcodeScannerController to show camera and scan for supportedCodeTypes.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isFirstRequest = true
        currentBookData.resetClassData()
        
        // Get the back-facing camera for capturing videos.
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard  let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialise a AVCaptureMetaDataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back.
            captureMetadataOutput.setMetadataObjectsDelegate((self as AVCaptureMetadataOutputObjectsDelegate), queue: DispatchQueue.main)
            
            // Set the supported code types.
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            // If any error occurs, print to console for debugging purposes.
            print(error)
            return
        }
        
        // Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label to the front.
        // NOTE: - This may be removed after ConfirmEntryController has been implemented.
        view.bringSubviewToFront(messageLabel)
        
        // Initialise the Code Frame to show user where to place code.
        barcodeFrameView = UIView()
        
        if let barcodeFrameView = barcodeFrameView {
            barcodeFrameView.layer.borderColor = UIColor.green.cgColor
            barcodeFrameView.layer.borderWidth = 2
            view.addSubview(barcodeFrameView)
            view.bringSubviewToFront(barcodeFrameView)
        }
        
        // Bringing the Navigation Bar infront of the camera view.
        blockView.layer.zPosition = 2
        navigationBar.layer.zPosition = 3
        
    }
    
    // MARK: - Handling Book Data
    func searchGoogleBooks(decodedURL : String) -> Bool {
        let session = URLSession.shared
        let client = GoogleBooksApiClient(session: session)
        
        let request = GoogleBooksApi.VolumeRequest.List(query: decodedURL)
        let task: URLSessionDataTask = client.invoke(
            request,
            onSuccess: { volumes in NSLog("\(volumes)")
                // Fill the found book with the data that has been retrieved from the API call.
                currentBookData.title = volumes.items[0].volumeInfo.title
                currentBookData.author = volumes.items[0].volumeInfo.authors
                currentBookData.isbn_10 = volumes.items[0].volumeInfo.industryIdentifiers[1].identifier
                currentBookData.isbn_13 = volumes.items[0].volumeInfo.industryIdentifiers[0].identifier
                // May not always have a publisher/publish date so conditional unwrapping to set default value to ""
                currentBookData.publisher = volumes.items[0].volumeInfo.publisher ?? ""
                currentBookData.published = volumes.items[0].volumeInfo.publishedDate ?? ""
                currentBookData.thumbnail = volumes.items[0].volumeInfo.imageLinks?.thumbnail
                
                lastBookTitle = currentBookData.title
                
                print("Book sent to controller")
                sentBookTitle = currentBookData.title
                
                // Perform segue in main dispatchQueue as the change of UI (PerformSegue) is best to be on the main thread.
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToConfirmEntry", sender: self)
                }
                
        },
            onError: { error in NSLog("\(error)")
                print("error")
        })
        task.resume()
        
        return !currentBookData.title.isEmpty
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToTabView", sender: self)
    }
    
}

extension BarcodeScannerController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            barcodeFrameView?.frame = CGRect.zero
            messageLabel.text = "Searching for barcode"
            return
        }
        
        // Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the barcode metadata then update the status label's text.
            
            let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            barcodeFrameView?.frame = barcodeObject!.bounds
            
            if isFirstRequest! {
                if metadataObj.stringValue != nil {
                    // This will segue to the ConfirmEntryController as the found code will be searched in the Google Books API
                    // NOTE: - Force unwrapping value in this case is fine as I check it is not nil.
                    
                    isFirstRequest = false
                    // Put your code which should be executed with a delay here
                    if self.searchGoogleBooks(decodedURL: metadataObj.stringValue!) {
                        // If the barcode is matched with the Google Books.
                        // If a book has been found prevent further API calls.
                        
                        print("Book sent to controller")
                        sentBookTitle = currentBookData.title
                        self.performSegue(withIdentifier: "goToConfirmEntry", sender: self)
                        
                    } else {
                        self.messageLabel.text = "Error: Cannot find book"
                    }
                    
                    isFirstRequest = false
                    print("setting first request to false")
                }
            }
            
        }
    }
}
