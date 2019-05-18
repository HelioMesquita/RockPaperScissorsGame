//
//  GameViewController+AVCapture.swift
//  rock-paper-scissors
//
//  Created by Hélio Mesquita on 12/05/19.
//  Copyright © 2019 Hélio Mesquita. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

extension GameViewController {

  func setupAVCapture() {
    var deviceInput: AVCaptureDeviceInput!

    // Select a video device, make an input
    let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
    do {
      deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
    } catch {
      print("Could not create video device input: \(error)")
      return
    }

    session.beginConfiguration()
    session.sessionPreset = .vga640x480 // Model image size is smaller.

    // Add a video input
    guard session.canAddInput(deviceInput) else {
      print("Could not add video device input to the session")
      session.commitConfiguration()
      return
    }
    session.addInput(deviceInput)
    if session.canAddOutput(videoDataOutput) {
      session.addOutput(videoDataOutput)
      // Add a video data output
      videoDataOutput.alwaysDiscardsLateVideoFrames = true
      videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
      videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
    } else {
      print("Could not add video data output to the session")
      session.commitConfiguration()
      return
    }
    let captureConnection = videoDataOutput.connection(with: .video)
    // Always process the frames
    captureConnection?.isEnabled = true
    do {
      try  videoDevice!.lockForConfiguration()
      let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
      bufferSize.width = CGFloat(dimensions.width)
      bufferSize.height = CGFloat(dimensions.height)
      videoDevice!.focusMode = .continuousAutoFocus
      videoDevice!.unlockForConfiguration()
    } catch {
      print(error)
    }
    session.commitConfiguration()
    previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    rootLayer = previewView.layer
    previewLayer.frame = rootLayer.bounds
    rootLayer.addSublayer(previewLayer)
  }

  func startCaptureSession() {
    session.startRunning()
  }
  
}

extension GameViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    do {
      try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform(requests)
    }
  }


}
