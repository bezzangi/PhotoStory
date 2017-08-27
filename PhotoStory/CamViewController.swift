//
//  CamViewController.swift
//  PhotoStory
//
//  Created by Younghwa Park on 24/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//
// https://stackoverflow.com/questions/28756363/how-to-capture-picture-with-avcapturesession-in-swift
// https://github.com/linhcn/AVCamSample


import UIKit
import AVFoundation

class CamViewController: UIViewController, AVCapturePhotoCaptureDelegate{
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    //  카메라 영상 표시 위한 뷰
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var captureSesssion: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    //var previewLayer: AVCaptureVideoPreviewLayer?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var input: AVCaptureDeviceInput?
    
    

    var previewView = UIView()
    
    var scrollView = PhotoScrollView()
    
    func updateTitle() {
        let count:Int = (PhotoManager.sharedInstance.imageArr?.count)!
        navigationBar.topItem?.title = "카메라 (\(count))"
    }
    
    func initUI() {
        
        let h = view.frame.height
        let w = view.frame.width
        
        let offset = 5
        var y = 70
        
        let width = w - 2 * CGFloat(offset)
        
        previewView.frame = CGRect(x: CGFloat(offset), y: CGFloat(y), width:width, height:width)
        previewView.alpha = 1.0
        previewView.isHidden = false
        previewView.layer.cornerRadius = 5
        //previewView.backgroundColor = UIColor.blue
        
        y = y + Int(width) + offset
        
        let height = Int(h) - y - offset - Int(toolBar.bounds.height)
        scrollView.initUI()
        
        scrollView.frame = CGRect(x: CGFloat(offset), y: CGFloat(y), width:width, height:CGFloat(height))
       
        view.addSubview(scrollView)
        view.addSubview(previewView)
    }

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "cancel") {
            PhotoManager.sharedInstance.imageArr?.removeAll()
            PhotoManager.sharedInstance.selectedStory = nil
            return true
        }
        if (PhotoManager.sharedInstance.imageArr?.count == 0) {
            let alert = UIAlertController(title: "", message: "사진을 1장 이상 촬영하세요.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        PhotoManager.sharedInstance.selectedStory = nil
        return true
    }
    
    @IBAction func takeItBtn(_ sender: AnyObject) {
        // 플래시 및 카메라 관련 설정
        let settingsForMonitoring = AVCapturePhotoSettings()
        //settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        //settingsForMonitoring.isHighResolutionPhotoEnabled = false
        settingsForMonitoring.isHighResolutionPhotoEnabled = true
        
        // 촬영셔터 누름
        
        //settingsForMonitoring.flashMode = position == .front || position == .unspecified ? .off : .auto
        settingsForMonitoring.flashMode = .off
        
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    var device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    override func viewWillAppear(_ animated: Bool) {
        
        captureSesssion = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        stillImageOutput?.isHighResolutionCaptureEnabled = true
        captureSesssion.sessionPreset = AVCaptureSessionPreset1920x1080 // 해상도설정
        
        //let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            //let
            input = try AVCaptureDeviceInput(device: device)
            
            // 입력
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                
                // 출력
                if (captureSesssion.canAddOutput(stillImageOutput)) {
                    captureSesssion.addOutput(stillImageOutput)
                    captureSesssion.startRunning() // 카메라 시작
                    initCamera()
                    initOutput()

                }
            }
        }
        catch {
            print(error)
        }
    }
    
    
    var ivx = 5
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let photoSampleBuffer = photoSampleBuffer {
            // JPEG형식으로 이미지데이터 검색
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)
       
            // 사진보관함에 저장
//            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            
            
            scrollView.addImage(image: image!)
                        
            PhotoManager.sharedInstance.imageArr?.append(image!)
        }
        
        updateTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var cameraKind = ".back"
    
    func initCamera() {
        //        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            captureSesssion = AVCaptureSession()
            captureSesssion?.addInput(input)
        } catch {
            print(error)
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //videoPreviewLayer?.frame = view.layer.bounds
        
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: previewView.bounds.width, height: previewView.bounds.height)
        
            //previewView.bounds
        
        previewView.layer.addSublayer(videoPreviewLayer!)
        previewView.clipsToBounds = true
        //captureSesssion.accessibilityFrame = previewView.frame
        
        captureSesssion?.startRunning()
        
    }
    
    func initOutput() {
        captureSesssion?.addOutput(stillImageOutput)
    }
    
    
    @IBAction func btnFrClicked(_ sender: Any) {
        captureSesssion.removeOutput(stillImageOutput)
        
        NSLog("FR~")
        //captureDevice = getDevice(.Back)
        if (cameraKind == ".front" ){
            //device = getDevice(position: .back)
            device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
            cameraKind = ".back"
            //            initCamera()
        } else {
            //device = getDevice(position: .front)
            device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
            cameraKind = ".front"
        }
        initCamera()
        captureSesssion.addOutput(stillImageOutput)
//        initOutput()
    }
    
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
}


extension UIImage {
    func fixOrientation() -> UIImage {
        
        var transform: CGAffineTransform = .identity
        
        transform = transform.translatedBy(x: 0, y: self.size.height);
        transform = transform.rotated(by: -.pi/2);

        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        ctx.draw(self.cgImage!, in: CGRect(x: 0.0,y: 0.0,width: self.size.width,height: self.size.height))

        return UIImage(cgImage: ctx.makeImage()!)
    }
    
    
}




