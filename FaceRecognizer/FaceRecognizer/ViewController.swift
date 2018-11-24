//
//  ViewController.swift
//  FaceRecognizer
//
//  Created by andy.bin on 2018/11/22.
//  Copyright © 2018 Binea. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//    var camera: CVCamera!
    var camera: APCamera!
    var cameraView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(cameraView)
        cameraView.frame = self.view.bounds
//        cameraView.center = self.view.center
        cameraView.backgroundColor = .black
//
//        camera = CVCamera(cameraView: cameraView, scale: 1)
//        camera.startCapture()
        
        camera = APCamera()
        camera.previewView = cameraView
        camera.prepare()
        camera.startRuning()
    }


}

