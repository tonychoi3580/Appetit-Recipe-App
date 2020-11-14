//
//  BarcodeScannerViewController.swift
//  appetit
//
//  Created by Frank Hu on 4/6/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

//Sample barcodes for testing
// https://docs.google.com/document/d/1hZ69q8BhEgEVHbFzQnPlGNPjyJycKWBDhY1jsT13np8/edit
//TODO: Add edge case errors for barcode with no search result from API

import UIKit
import AVFoundation

protocol DataSentDelegate{
    func sendDataToParent(myData: [String])
}

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate: DataSentDelegate?
    
    let scanView = UIView()
    let successView = UIView()
    let bottomBar = UIView()
    let textBar = UIView()
    let descriptionTextView: UILabel = {
        let textView = UILabel()
        textView.text = "Begin Scanning"
        textView.numberOfLines = 2
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    let closeButton = UIButton(type: .system)
    let rescanButton = UIButton(type: .system)
    let addButton = UIButton(type: .system)
    let imageView = UIImageView()
        
        var captureSession = AVCaptureSession()
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
//        var BarcodeFrameView: UIView?
        
        private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
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
                                           AVMetadataObject.ObjectType.qr]
        
        override func viewDidLoad() {
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                // Already Authorized
            } else {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                   if granted == true {
                       // User granted
                   } else {
                       // User rejected
//                        self.scanningNotPossible()
                   }
               })
            }
            super.viewDidLoad()
            setupLayout()
            closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
            rescanButton.addTarget(self, action: #selector(rescanTapped), for: .touchUpInside)
            addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
            successView.isHidden = true
            
            if currentReachabilityStatus == .notReachable {
                DispatchQueue.main.async{
                let alert = UIAlertController(title: "No Internet Connection", message: "There is a problem connecting to appetit. Please try again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (s) in}))
                self.present(alert, animated: true, completion: nil)
                }
            }
            captureSession = AVCaptureSession()
            
//            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
             
//            guard let captureDevice = deviceDiscoverySession.devices.first else {
//                print("Failed to get the camera device")
//                return
//            }
            guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
            let input: AVCaptureDeviceInput
            
            do {
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                input = try AVCaptureDeviceInput(device: captureDevice)
            } catch {
                return
            }
            
            if (captureSession.canAddInput(input)){
                captureSession.addInput(input)
            } else{
                DispatchQueue.main.async{
                let ac = UIAlertController(title: "Scanning not supported on device.", message: "Please use a device with a camera.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title:"OK", style: .default))
                    self.present(ac, animated:true, completion: nil)
                }
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (captureSession.canAddOutput(metadataOutput)){
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = self.supportedCodeTypes
            } else {
                 let ac = UIAlertController(title: "Scanning not supported on device.", message: "Please use a device with a camera.", preferredStyle: .alert)
                 ac.addAction(UIAlertAction(title:"OK", style: .default))
                 present(ac, animated:true)
                return
            }
                
//                // Set the input device on the capture session.
//                captureSession.addInput(input)
//
//                // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
//                let metadataOutput = AVCaptureMetadataOutput()
//                captureSession.addOutput(metadataOutput)
//
//                // Set delegate and use the default dispatch queue to execute the call back
//                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//                metadataOutput.metadataObjectTypes = self.supportedCodeTypes
//    //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//
//            } catch {
//                print(error)
////                let ac = UIAlertController(title: "Scanning not supported on device.", message: "Please use a device with a camera.", preferredStyle: .alert)
////                ac.addAction(UIAlertAction(title:"OK", style: .default))
////                present(ac, animated:true)
//                return
//            }
//
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = scanView.layer.frame
            view.layer.addSublayer(videoPreviewLayer!)
            view.bringSubviewToFront(imageView)
            view.bringSubviewToFront(successView)

            
            // Start video capture.
            captureSession.startRunning()
            
//             Initialize Code Frame to highlight the code
///           BarcodeFrameView = UIView()
//
//            if let BarcodeFrameView = BarcodeFrameView {
//                BarcodeFrameView.layer.backgroundColor = UIColor.blue.cgColor
//                BarcodeFrameView.layer.borderWidth = 2
//                view.addSubview(BarcodeFrameView)
//                view.bringSubviewToFront(BarcodeFrameView)
//            }
        }

    
    @objc func closeTapped(sender: UIButton) {
        print("Scanner closed")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func rescanTapped(sender: UIButton) {
         print("Rescan tapped")
         successView.isHidden = true
        textBar.backgroundColor = #colorLiteral(red: 0.7882760763, green: 1, blue: 0.8077354431, alpha: 1)
         captureSession.startRunning()
        descriptionTextView.text = "No Barcode is detected"
     }
    
    @objc func addTapped(sender: UIButton) {
        if delegate != nil{
            if (self.descriptionTextView.text != "Begin Scanning") {
                if(self.descriptionTextView.text != "No Barcode is detected"){
                    let multiLineString = self.descriptionTextView.text
                    var lineArray = [String]()
                    multiLineString?.enumerateLines { (line, stop) -> () in
                        lineArray.append(line)
                    }
                    let dataToBeSent = lineArray
                    delegate?.sendDataToParent(myData: dataToBeSent)
        //            print("Scanner closed + Added")
                    self.dismiss(animated:true, completion: nil)
        }
        }
     }
    }
     
        private func setupLayout() {
            let topBar = UIView()
            topBar.backgroundColor = .white
            view.addSubview(topBar)
            topBar.translatesAutoresizingMaskIntoConstraints = false
            topBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            topBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13).isActive = true
            
            
            
            scanView.backgroundColor = .yellow
            view.addSubview(scanView)
            scanView.translatesAutoresizingMaskIntoConstraints = false
            scanView.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
            scanView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            scanView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            scanView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
            
            bottomBar.backgroundColor = .white
            view.addSubview(bottomBar)
            bottomBar.translatesAutoresizingMaskIntoConstraints = false
            bottomBar.topAnchor.constraint(equalTo: scanView.bottomAnchor).isActive = true
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            
            bottomBar.topAnchor.constraint(equalTo: scanView.bottomAnchor).isActive = true
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

            textBar.backgroundColor = #colorLiteral(red: 0.7882760763, green: 1, blue: 0.8077354431, alpha: 1)
            textBar.translatesAutoresizingMaskIntoConstraints = false
            view.bringSubviewToFront(textBar)
            view.addSubview(textBar)
            
            textBar.addSubview(descriptionTextView)
//                descriptionTextView.backgroundColor = .red
            descriptionTextView.topAnchor.constraint(equalTo: textBar.topAnchor).isActive = true
            descriptionTextView.bottomAnchor.constraint(equalTo: textBar.bottomAnchor).isActive = true
            descriptionTextView.leftAnchor.constraint(equalTo: textBar.leftAnchor).isActive = true
            descriptionTextView.rightAnchor.constraint(equalTo: textBar.rightAnchor).isActive = true
            
            textBar.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 20).isActive = true
            textBar.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant:-300).isActive = true
            textBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            textBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//            textBar.layer.borderWidth = 1.0
//            textBar.layer.cornerRadius = 10.0
//            textBar.clipsToBounds = true
//            textBar.layer.borderColor = UIColor.clear.cgColor
//            textBar.layer.shadowColor = UIColor.lightGray.cgColor
//            textBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//            textBar.layer.shadowRadius = 2.0
//            textBar.layer.shadowOpacity = 0.7
//            textBar.layer.masksToBounds = false
            descriptionTextView.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
            descriptionTextView.textAlignment = .center
            
            topBar.addSubview(closeButton)
            let img = UIImage(named: "close")
            closeButton.setImage(img, for: .normal)
            closeButton.contentMode = .scaleAspectFit
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            closeButton.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: -20).isActive = true
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            view.bringSubviewToFront(closeButton)
            
            addButton.setTitle("Add", for: .normal)
            addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            addButton.setTitleColor(UIColor.black, for: .normal)
            addButton.contentMode = .scaleAspectFit
            addButton.translatesAutoresizingMaskIntoConstraints = false
            view.bringSubviewToFront(addButton)
            
            let addBar = UIView()
            addBar.backgroundColor = #colorLiteral(red: 0.9899876714, green: 0.9562074542, blue: 0.9259331226, alpha: 1)
            addBar.translatesAutoresizingMaskIntoConstraints = false
            addBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(addBar)
            view.bringSubviewToFront(addBar)
            view.addSubview(addButton)

            addBar.addSubview(addButton)
            
            addButton.topAnchor.constraint(equalTo: addBar.topAnchor).isActive = true
            addButton.bottomAnchor.constraint(equalTo: addBar.bottomAnchor).isActive = true
            addButton.leftAnchor.constraint(equalTo: addBar.leftAnchor).isActive = true
            addButton.rightAnchor.constraint(equalTo: addBar.rightAnchor).isActive = true
            
            addBar.topAnchor.constraint(equalTo: textBar.bottomAnchor, constant: 15).isActive = true
            addBar.bottomAnchor.constraint(equalTo: textBar.bottomAnchor, constant: 65).isActive = true
            addBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            addBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
            addBar.layer.borderWidth = 1.0
            addBar.layer.cornerRadius = 10.0
            addBar.clipsToBounds = true
            addBar.layer.borderColor = UIColor.clear.cgColor
            addBar.layer.shadowColor = UIColor.lightGray.cgColor
            addBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            addBar.layer.shadowRadius = 2.0
            addBar.layer.shadowOpacity = 0.7
            addBar.layer.masksToBounds = false
            
            view.bringSubviewToFront(addBar)
            
            rescanButton.setTitle("Rescan", for: .normal)
            rescanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            rescanButton.setTitleColor(UIColor.black, for: .normal)
            rescanButton.contentMode = .scaleAspectFit
            rescanButton.translatesAutoresizingMaskIntoConstraints = false
            view.bringSubviewToFront(rescanButton)
            
            let rescanBar = UIView()
            rescanBar.backgroundColor = #colorLiteral(red: 0.9899876714, green: 0.9562074542, blue: 0.9259331226, alpha: 1)
            rescanBar.translatesAutoresizingMaskIntoConstraints = false
            rescanButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(rescanBar)
            view.bringSubviewToFront(rescanBar)
            view.addSubview(rescanButton)

            rescanBar.addSubview(rescanButton)
            
            rescanButton.topAnchor.constraint(equalTo: rescanBar.topAnchor).isActive = true
            rescanButton.bottomAnchor.constraint(equalTo: rescanBar.bottomAnchor).isActive = true
            rescanButton.leftAnchor.constraint(equalTo: rescanBar.leftAnchor).isActive = true
            rescanButton.rightAnchor.constraint(equalTo: rescanBar.rightAnchor).isActive = true
            
            rescanBar.topAnchor.constraint(equalTo: addBar.bottomAnchor, constant: 15).isActive = true
            rescanBar.bottomAnchor.constraint(equalTo: addBar.bottomAnchor, constant:65).isActive = true
            rescanBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            rescanBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
            rescanBar.layer.borderWidth = 1.0
            rescanBar.layer.cornerRadius = 10.0
            rescanBar.clipsToBounds = true
            rescanBar.layer.borderColor = UIColor.clear.cgColor
            rescanBar.layer.shadowColor = UIColor.lightGray.cgColor
            rescanBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            rescanBar.layer.shadowRadius = 2.0
            rescanBar.layer.shadowOpacity = 0.7
            rescanBar.layer.masksToBounds = false
            
            view.bringSubviewToFront(rescanBar)
            
            imageView.image = UIImage(named: "barView")
            imageView.alpha = 0.5
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            imageView.centerYAnchor.constraint(equalTo: scanView.centerYAnchor, constant: 10).isActive = true
            imageView.centerXAnchor.constraint(equalTo: scanView.centerXAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: scanView.heightAnchor, multiplier: 0.9).isActive = true
//                imageView.Anchor.constraint(equalTo: view.rightAnchor).isActive = true
            
            successView.backgroundColor = #colorLiteral(red: 0.3914206922, green: 0.9923465848, blue: 0.4027332067, alpha: 0.3415560788)
            view.addSubview(successView)
            successView.translatesAutoresizingMaskIntoConstraints = false
            successView.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
            successView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            successView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            successView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true

        }
    
    
//    func scanningNotPossible(){
//        let alert = UIAlertController(title: "Can't Scan", message: "Try a device with camera", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            // Check if the metadataObjects array is not nil and it contains at least one object.
            if metadataObjects.count == 0 {
                descriptionTextView.text = "No Barcode is detected"
                successView.isHidden = true
                return
            }
            
            // Get first object from metadata objects array and turn it into machine readable code.
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            if supportedCodeTypes.contains(metadataObj.type) {
                successView.isHidden = false
                
                if metadataObj.stringValue != nil {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    captureSession.stopRunning()
                    let numberString = metadataObj.stringValue
                    //Remove leading zeros of scanned string value for correct UPC search
                    let num = numberString!.drop { !$0.isWholeNumber || $0 == "0" }
                    DataService.searchAPI(codeNumber: String(num)){
                        foodInfo in
                        DispatchQueue.main.async{
                            if (foodInfo.0 != "error"){
                                self.descriptionTextView.text = "\(foodInfo.0)\n\(foodInfo.1)"
                            }
                            else {
                                self.textBar.backgroundColor = #colorLiteral(red: 1, green: 0.6393242478, blue: 0.6698779464, alpha: 1)
                                self.descriptionTextView.text = "Product not available.\nScan again."
                            }
                        }
                    }
//                    print ("here + \(foodInfo)")
//                    messageLabel.text = "\(foodInfo.name)"
                }
            }

        //Function when QR Code detected
//    func found(value: String) -> (name:String, qty:Float, unit:String) {
//        var name = ""
//        var qty = Float(0)
//        var unit = ""
//        DataService.searchAPI(codeNumber: value){
//            foodInfo in
//            name = foodInfo.0
//            qty = foodInfo.1
//            unit = foodInfo.2
//        }
//        print(name, qty, unit)
//        return (name, qty, unit)
//            print(scanInfo.0)
//            messageLabel.text = "\(scanInfo.0) hello"
//            let alert = UIAlertController(title: "Scanned", message: "\(value)", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title:"Search", style: UIAlertAction.Style.destructive, handler: { action in
//                DataService.searchAPI(codeNumber: value)
//                self.present(alert, animated:true, completion: nil)
//            }))
    }
            
//            let alert = UIAlertController(title: "Scanned", message: value, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Search", style: UIAlertAction.Style.destructive, handler:
//
//
//            ))
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
//                    alert.addAction(cancelAction)
        private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
          layer.videoOrientation = orientation
            videoPreviewLayer?.frame = self.scanView.layer.frame
        }
        
        override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          
          if let connection =  self.videoPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            
            if previewLayerConnection.isVideoOrientationSupported {
              switch (orientation) {
              case .portrait:
                updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                break
              case .landscapeRight:
                updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                break
              case .landscapeLeft:
                updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                break
              case .portraitUpsideDown:
                updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                break
              default:
                updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                break
              }
            }
          }
        }
        
    }
