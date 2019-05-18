//
//  GameViewController+Vision.swift
//  rock-paper-scissors
//
//  Created by Hélio Mesquita on 12/05/19.
//  Copyright © 2019 Hélio Mesquita. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

extension GameViewController {

  func setupVision() {
    setupLayers()
    updateLayerGeometry()
    setupML()
  }

  private func setupML() {
    if let visionModel = try? VNCoreMLModel(for: RockPaperScissors().model) {
      let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: handleVNCoreMLRequest)
      self.requests = [objectRecognition]
    }
  }

  private func handleVNCoreMLRequest(_ finishedRequest: VNRequest, _ error: Error?) {
    DispatchQueue.main.async {
      guard let results = finishedRequest.results else { return }

      CATransaction.begin()
      CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
      self.detectionOverlay.sublayers = nil

      for observation in results where observation is VNRecognizedObjectObservation {
        guard let objectObservation = observation as? VNRecognizedObjectObservation else {
          continue
        }

        // Select only the label with the highest confidence.
        let topLabelObservation = objectObservation.labels[0]
        let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(self.bufferSize.width), Int(self.bufferSize.height))

        switch topLabelObservation.identifier {
        case RockPaperScissorsIdentifier.rock.rawValue:
          self.userHandSign = .rock
        case RockPaperScissorsIdentifier.scissors.rawValue:
          self.userHandSign = .scissors
        case RockPaperScissorsIdentifier.paper.rawValue:
          self.userHandSign = .paper
        default:
          break
        }

        let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
        let textLayer = self.createTextSubLayerInBounds(objectBounds, identifier: topLabelObservation.identifier, confidence: topLabelObservation.confidence)
        shapeLayer.addSublayer(textLayer)
        self.detectionOverlay.addSublayer(shapeLayer)
      }
      self.updateLayerGeometry()
      CATransaction.commit()
    }

  }

  func setupLayers() {
    detectionOverlay = CALayer() // container layer that has all the renderings of the observations
    detectionOverlay.name = "DetectionOverlay"
    detectionOverlay.bounds = CGRect(x: 0.0,
                                     y: 0.0,
                                     width: bufferSize.width,
                                     height: bufferSize.height)
    detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
    rootLayer.addSublayer(detectionOverlay)
  }

  func updateLayerGeometry() {
    let bounds = rootLayer.bounds
    var scale: CGFloat

    let xScale: CGFloat = bounds.size.width / bufferSize.height
    let yScale: CGFloat = bounds.size.height / bufferSize.width

    scale = fmax(xScale, yScale)
    if scale.isInfinite {
      scale = 1.0
    }
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)

    detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
    detectionOverlay.position = CGPoint (x: bounds.midX, y: bounds.midY)

    CATransaction.commit()

  }

  func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
    let textLayer = CATextLayer()
    textLayer.name = "Object Label"
    let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence:  %.2f", confidence))
    let largeFont = UIFont(name: "Helvetica", size: 24.0)!
    formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
    textLayer.string = formattedString
    textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
    textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    textLayer.shadowOpacity = 0.7
    textLayer.shadowOffset = CGSize(width: 2, height: 2)
    textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
    textLayer.contentsScale = 2.0 // retina rendering
    // rotate the layer into screen orientation and scale and mirror
    textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
    return textLayer
  }

  func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
    let shapeLayer = CALayer()
    shapeLayer.bounds = bounds
    shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    shapeLayer.name = "Found Object"
    shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
    shapeLayer.cornerRadius = 7
    return shapeLayer
  }

}

