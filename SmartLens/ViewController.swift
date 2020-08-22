//
//  ViewController.swift
//  SmartLens
//
//  Created by Kishlay Chhajer on 2020-08-21.
//  Copyright © 2020 Kishlay Chhajer. All rights reserved.
//

import UIKit
import AVKit
import CoreML
import Vision


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            if let input = try? AVCaptureDeviceInput(device: device) {
                session.addInput(input)
                session.startRunning()
                let preview = AVCaptureVideoPreviewLayer(session: session)
                view.layer.addSublayer(preview)
                preview.frame = view.frame
                let output = AVCaptureVideoDataOutput()
                output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "dispatchQueue"))
                session.addOutput(output)
        }
    }
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let pixel : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            if let model = try? VNCoreMLModel(for: Resnet50().model) {
            let request = VNCoreMLRequest(model: model) { (requests, error) in
                if let results = requests.results as? [VNClassificationObservation] {
                    DispatchQueue.main.async {
                        self.navigationItem.title = results.first?.identifier
                    }
                    
                }
                }
            try? VNImageRequestHandler(cvPixelBuffer: pixel, options: [:]).perform([request])
            }
        }
    }


}

