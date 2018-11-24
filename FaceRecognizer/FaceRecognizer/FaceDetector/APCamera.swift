//
//  APCamera.swift
//  FaceRecognizer
//
//  Created by andy.bin on 2018/11/23.
//  Copyright © 2018 Binea. All rights reserved.
//

import Foundation
import AVFoundation
import CoreImage


class APCamera: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let captureSession = AVCaptureSession()
    let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var previewLayer: AVCaptureVideoPreviewLayer
    let context: CIContext
    let faceDetector: CIDetector
    let faceFrameLayer: CAShapeLayer
    var count = 1
    let imageView = UIImageView()
    
    var previewView: UIView? {
        didSet {
            previewLayer.removeFromSuperlayer()
            if let view = previewView {
                previewLayer.frame = view.bounds
                faceFrameLayer.frame = view.bounds
                view.layer.insertSublayer(previewLayer, at: 0)
                view.layer.addSublayer(faceFrameLayer)
                imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                imageView.contentMode = .scaleAspectFit
                imageView.backgroundColor = UIColor.gray
                view.addSubview(imageView)
            }
        }
    }
    
    override init() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        context = CIContext()
        faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: nil)!
        faceFrameLayer = CAShapeLayer()
        super.init()
        faceFrameLayer.lineWidth = 1
        faceFrameLayer.fillColor = UIColor.clear.cgColor
        faceFrameLayer.strokeColor = UIColor.blue.cgColor
//        faceFrameLayer.backgroundColor = UIColor.red.withAlphaComponent(0.5).cgColor
        
        
    }
    
    func prepare() {
        captureSession.beginConfiguration()
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput) else {
            print("prepare videoDeviceInput error")
            return
        }
        captureSession.addInput(videoDeviceInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        guard captureSession.canAddOutput(videoOutput) else {
            print("prepare videoOutput error")
            return
        }
        
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        captureSession.addOutput(videoOutput)
        captureSession.commitConfiguration()
    }
    
    func startRuning() {
        if captureSession.isRunning {
            return
        }
        captureSession.startRunning()
    }
    
    //MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        count += 1
        if count % 5 != 0 {
            
            return
        }
        count = 0
        guard let cvPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
//        let ciImage = CIImage(cvPixelBuffer: cvPixelBuffer)
//        let ciImage = CIImage(cvImageBuffer: cvPixelBuffer, options: [CIImageOption.applyOrientationProperty: CGImagePropertyOrientation.rightMirrored.rawValue])
        let ciImage = CIImage(cvPixelBuffer: cvPixelBuffer).oriented(forExifOrientation: Int32(CGImagePropertyOrientation.leftMirrored.rawValue))
//        let fetures = faceDetector.features(in: ciImage, options: [CIDetectorImageOrientation: CGImagePropertyOrientation.rightMirrored.rawValue])
        let fetures = faceDetector.features(in: ciImage)
        print("fetures count:\(fetures.count)")
        print("ciImage.extent:\(ciImage.extent)")
        print("self.previewLayer.bounds:\(self.previewLayer.bounds)")
        let scaleX = self.previewLayer.bounds.width / ciImage.extent.size.width
        let scaleY = self.previewLayer.bounds.height / ciImage.extent.size.height
        let scale = min(scaleX, scaleY)
        
        let offsetY = (self.previewLayer.bounds.height - ciImage.extent.size.height * scale)
        print("offsetY:\(offsetY)")
//        let transform = CGAffineTransform.init(scaleX: scale, y: scale).scaledBy(x: -1, y: -1).translatedBy(x: -self.previewLayer.bounds.width, y: -self.previewLayer.bounds.height).translatedBy(x: 0, y: offsetY)
        
        let transform = CGAffineTransform.init(scaleX: scale, y: -scale).translatedBy(x: 0, y: -ciImage.extent.size.height - offsetY)
        
        let feturesPath = UIBezierPath()
        for feture in fetures {
            if let feture  = feture as? CIFaceFeature {
                print("feture.bounds:",feture.bounds)
                let scaleFrame = feture.bounds.applying(transform)
                print("scaleFrame:", scaleFrame)
                let facePath = UIBezierPath.init(rect: scaleFrame)
                
                let leftEyePoint = feture.leftEyePosition.applying(transform)
                let leftEyePath = UIBezierPath.init(rect: CGRect(x: leftEyePoint.x - 5, y: leftEyePoint.y - 5, width: 10, height: 10))
                
                let rightEyePoint = feture.rightEyePosition.applying(transform)
                let rightEyePath = UIBezierPath.init(rect: CGRect(x: rightEyePoint.x - 5, y: rightEyePoint.y - 5, width: 10, height: 10))
                
                let mouthPoint = feture.mouthPosition.applying(transform)
                let mouthPath = UIBezierPath.init(rect: CGRect(x: mouthPoint.x - 25, y: mouthPoint.y - 10, width: 50, height: 20))
                
                feturesPath.append(facePath)
                feturesPath.append(leftEyePath)
                feturesPath.append(rightEyePath)
                feturesPath.append(mouthPath)
            }
        }
        DispatchQueue.main.async {
            self.faceFrameLayer.path = feturesPath.cgPath
            self.imageView.image = UIImage(ciImage: ciImage)
        }
    }
}
