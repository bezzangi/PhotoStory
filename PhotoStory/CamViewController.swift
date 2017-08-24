//
//  CamViewController.swift
//  PhotoStory
//
//  Created by Younghwa Park on 24/08/2017.
//  Copyright © 2017 Bezzangi. All rights reserved.
//

import UIKit
import AVFoundation

class CamViewController: UIViewController, AVCapturePhotoCaptureDelegate{
    
    
    //  카메라 영상 표시 위한 뷰
    @IBOutlet weak var cameraView: UIView!
    
    var captureSesssion: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var input: AVCaptureDeviceInput?
    
    
    @IBAction func takeItBtn(_ sender: AnyObject) {
        // 플래시 및 카메라 관련 설정
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        // 촬영셔터 누름
        
        let position = input?.device.position
        settingsForMonitoring.flashMode = position == .front || position == .unspecified ? .off : .auto
        
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        captureSesssion = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        
        captureSesssion.sessionPreset = AVCaptureSessionPreset1920x1080 // 해상도설정
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
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
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect //화면 조절
                    previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait // 카메라 방향
                    
                    cameraView.layer.addSublayer(previewLayer!)
                    
                    // 뷰 크기 조절
                    previewLayer?.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                    previewLayer?.bounds = cameraView.frame
                }
            }
        }
        catch {
            print(error)
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
