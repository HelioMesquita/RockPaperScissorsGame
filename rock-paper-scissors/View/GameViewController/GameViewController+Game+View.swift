//
//  GameViewController+GameRules.swift
//  rock-paper-scissors
//
//  Created by Hélio Mesquita on 12/05/19.
//  Copyright © 2019 Hélio Mesquita. All rights reserved.
//

import UIKit

extension GameViewController {

  func setupGame() {
    addButton()
  }

  @objc private func play(sender: UIButton) {
    userHandSign = nil // reset game
    computerHandSign = nil // reset game
    sender.isHidden = true
    startCountdown()
  }

  private func startCountdown() {
    timeLeft = totalTime
    addCountdownLabel()
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerHit), userInfo: nil, repeats: true)
  }

  @objc func timerHit() {
    if timeLeft == 0 {
      endCountdown()
    } else {
      decrementCountdown()
    }
  }

  private func decrementCountdown() {
    timeLeft -= 1
    getCountDownLabel().text = "\(timeLeft)"
  }

  private func endCountdown() {
    timer.invalidate()
    getCountDownLabel().removeFromSuperview()
    getButton().isHidden = false

    if let user = userHandSign, let computer = RockPaperScissorsIdentifier.allCases.randomElement() {
      let result = RockPaperScissorsResult(userHandSign: user, computerHandSign: computer)
      let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultViewController") as! ResultViewController
      viewController.result = result
      present(viewController, animated: true, completion: nil)
    } else {
      let alertController = UIAlertController(title: nil, message: "No hand identified, try again", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
    }
  }

}

extension GameViewController {

  private func getCountDownLabel() -> UILabel {
    return self.view.subviews.first(where: { $0.restorationIdentifier == "countdownLabel" }) as! UILabel
  }

  private func getButton() -> UIButton {
    return self.view.subviews.first(where: { $0.restorationIdentifier == "startButton" }) as! UIButton
  }

  private func addCountdownLabel() {
    let label = UILabel()
    label.backgroundColor = UIColor.white
    label.tintColor = UIColor.black
    label.text = "\(timeLeft)"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = label.font.withSize(100)
    label.layer.cornerRadius = 4
    label.layer.borderColor = UIColor.black.cgColor
    label.layer.borderWidth = 1
    label.alpha = 0.75
    label.backgroundColor = UIColor.white
    label.clipsToBounds = true
    label.textAlignment = .center

    label.restorationIdentifier = "countdownLabel"
    self.view.addSubview(label)

    NSLayoutConstraint.activate([
      label.widthAnchor.constraint(equalToConstant: 100),
      label.heightAnchor.constraint(equalToConstant: 100),
      label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
      ])

  }

  private func addButton() {
    let button = UIButton(frame: .zero)
    button.setTitle("Start", for: .normal)
    button.layer.cornerRadius = 24
    button.setTitleColor(UIColor.black, for: .normal)
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 1
    button.backgroundColor = UIColor.white
    button.alpha = 0.75
    button.clipsToBounds = true
    button.restorationIdentifier = "startButton"
    button.addTarget(self, action: #selector(play(sender:)), for: .touchUpInside)

    button.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(button)
    button.bringSubviewToFront(button)

    NSLayoutConstraint.activate([
      button.heightAnchor.constraint(equalToConstant: 48),
      button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
      button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
      button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
      ])

  }

}
