//
//  ViewController.swift
//  FaceRecognizer
//
//  Created by andy.bin on 2018/11/22.
//  Copyright © 2018 Binea. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var camera: CVCamera!
    var cameraView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(cameraView)
        cameraView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 480, height: 640))
        cameraView.center = self.view.center
        cameraView.backgroundColor = .black
        
        camera = CVCamera(cameraView: cameraView, scale: 1)
        
        camera.startCapture()
    }


}

