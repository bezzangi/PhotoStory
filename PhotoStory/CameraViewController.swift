//
//  CameraViewController.swift
//  PhotoStory
//
//  Created by Bezzangi on 24/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//


// http://jamesonquave.com/blog/taking-control-of-the-iphone-camera-in-ios-8-with-swift-part-1/
// https://medium.com/@rizwanm/https-medium-com-rizwanm-swift-camera-part-1-c38b8b773b2

// https://swifter.kr/2016/10/19/swift-3-0%EC%97%90%EC%84%9C-%EC%B9%B4%EB%A9%94%EB%9D%BC-%EC%82%AC%EC%9A%A9%EC%9E%90%EC%A0%95%EC%9D%98-%EB%B0%A9%EB%B2%95/


import UIKit
import AVFoundation




class CameraViewController: UIViewController , AVCapturePhotoCaptureDelegate{
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var previewView = UIView()
    var stillImageOutput: AVCapturePhotoOutput?
    
    
    func initUI() {

        let h = view.frame.height
        
        let w = view.frame.width

        
        
        let offset = 20
        var y = 80
        
        let width = w - 2 * CGFloat(offset)
        
        previewView.frame = CGRect(x: CGFloat(offset), y: CGFloat(y), width:width, height:width)
        
//        previewView.frame = CGRect(x: CGFloat(offset), y: CGFloat(y), width: w - 2 * CGFloat(offset), height: h - CGFloat(y) - CGFloat(offset))
//        

//        previewView.frame = CGRect(x:0, y:0, width:w, height:h)

        previewView.alpha = 1.0
        previewView.isHidden = false
        previewView.backgroundColor = UIColor.white
        previewView.layer.cornerRadius = 5
        previewView.backgroundColor = UIColor.blue
        
        view.addSubview(previewView)

    
    }
    
    var captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    func initOutput() {
        captureSession?.addOutput(stillImageOutput)
    }
    
    func initCamera() {
//        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
        } catch {
            print(error)
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        
        previewView.layer.addSublayer(videoPreviewLayer!)
        previewView.clipsToBounds = true
        
        
        captureSession?.startRunning()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stillImageOutput = AVCapturePhotoOutput()
        
        initUI()
        initCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnShutterClicked(_ sender: Any) {
        NSLog("Photo~")
        
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        // 촬영셔터 누름
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self as! AVCapturePhotoCaptureDelegate)
    }

    
    func getDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices: NSArray = AVCaptureDevice.devices() as! NSArray;
        for de in devices {
            let deviceConverted = de as! AVCaptureDevice
            if(deviceConverted.position == position){
                return deviceConverted
            }
        }
        return nil
    }
    
    var cameraKind = ".back"
    
    @IBAction func btnFrClicked(_ sender: Any) {
        NSLog("FR~")
        //captureDevice = getDevice(.Back)
        if (cameraKind == ".front" ){
            captureDevice = getDevice(position: .back)
            cameraKind = ".back"
//            initCamera()
        } else {
            captureDevice = getDevice(position: .front)
            cameraKind = ".front"
        }
        initCamera()
        initOutput()
    }
    

    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let photoSampleBuffer = photoSampleBuffer {
            // JPEG형식으로 이미지데이터 검색
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)
            
            // 사진보관함에 저장
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }
    
    
//    func toggleFlash() {
//        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//        if (device?.hasTorch)! {
//            do {
//                try device?.lockForConfiguration()
//                if (device?.torchMode == AVCaptureTorchMode.on) {
//                    device?.torchMode = AVCaptureTorchMode.off
//                } else {
//                    do {
//                        try device?.setTorchModeOnWithLevel(1.0)
//                    } catch {
//                        print(error)
//                    }
//                }
//                device?.unlockForConfiguration()
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//    
    func toggleFlash() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
            } catch {
                
            }
            let torchOn = !(device?.isTorchActive)!
            
            do {
                try device?.setTorchModeOnWithLevel(1.0)
            } catch {
                
            }
            device?.torchMode = torchOn ? AVCaptureTorchMode.on : AVCaptureTorchMode.off
            device?.unlockForConfiguration()
        }
    }
    
    
    @IBAction func btnFlashClicked(_ sender: Any) {
        NSLog("Flash~")
        toggleFlash()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
