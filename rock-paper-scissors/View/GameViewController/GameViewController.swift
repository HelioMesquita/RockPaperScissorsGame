//
//  GameViewController.swift
//  rock-paper-scissors
//
//  Created by Hélio Mesquita on 11/05/19.
//  Copyright © 2019 Hélio Mesquita. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

class GameViewController: UIViewController {

  @IBOutlet weak var previewView: UIView!

  //Timer Control
  var timer: Timer = Timer()
  var totalTime = 5
  var timeLeft = 0

  //Camera Control
  var bufferSize: CGSize = .zero
  var rootLayer: CALayer! = nil
  let session = AVCaptureSession()
  var previewLayer: AVCaptureVideoPreviewLayer! = nil
  let videoDataOutput = AVCaptureVideoDataOutput()
  let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

  //Vision Control
  var detectionOverlay: CALayer! = nil
  var requests = [VNRequest]()

  //Game Control
  var shouldAnalyze = false
  var precision: Float = 0
  var userHandSign: RockPaperScissorsIdentifier?
  var computerHandSign: RockPaperScissorsIdentifier?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupAVCapture()
    setupVision()
    startCaptureSession()
    setupGame()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    previewLayer.frame = previewView.bounds
  }

}

