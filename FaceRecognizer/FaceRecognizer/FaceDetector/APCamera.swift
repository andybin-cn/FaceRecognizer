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
    let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
    var previewLayer: AVCaptureVideoPreviewLayer
    let context: CIContext
    let faceDetector: CIDetector
    
    var previewView: UIView? {
        didSet {
            previewLayer.removeFromSuperlayer()
            if let view = previewView {
                previewLayer.frame = view.bounds
                view.layer.insertSublayer(previewLayer, at: 0)
            }
        }
    }
    
    override init() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        context = CIContext()
        faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorTracking: true, CIDetectorMinFeatureSize: CGSize(width: 20, height: 20)])!
        super.init()
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
        guard let cvPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let ciImage = CIImage(cvPixelBuffer: cvPixelBuffer)
        let fetures = faceDetector.features(in: ciImage)
        for feture in fetures {
            if(feture is CIFaceFeature) {
                
            }
        }
        
    }
}
