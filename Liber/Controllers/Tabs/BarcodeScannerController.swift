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

class BarcodeScannerController: UIViewController {
    
    @IBOutlet var messageLabel: UILabel!
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var barcodeFrameView: UIView?
    
    // Listing supported datatypes for the barcode.
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.ean8,
                                     AVMetadataObject.ObjectType.ean13,]
    
    /*private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
            captureMetadataOutput.setMetadataObjectsDelegate((self as! AVCaptureMetadataOutputObjectsDelegate), queue: DispatchQueue.main)
            
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
        
    }
    
    func searchGoogleBooks(decodedURL: String) {
        // Function to be implemented in a later version, to pass a code in and this function will search the Google Books API for a proper entry. 
    }
}

extension BarcodeScannerController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            barcodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No barcode is detected"
            return
        }
        
        // Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the barcode metadata then update the status label's text.
            
            let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            barcodeFrameView?.frame = barcodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                // NOTE: - In a later update, this will segue to the ConfirmEntryController as the found code will be searched in the Google Books API and return the data available for a book to be added.
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
}
