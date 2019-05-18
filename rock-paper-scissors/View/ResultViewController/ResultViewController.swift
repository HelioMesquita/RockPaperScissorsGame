//
//  ResultViewController.swift
//  rock-paper-scissors
//
//  Created by Hélio Mesquita on 18/05/19.
//  Copyright © 2019 Hélio Mesquita. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

  var result: RockPaperScissorsResult?

  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var computerLabel: UILabel!
  @IBOutlet weak var buttonOut: UIButton!

  @IBAction func backAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    buttonOut.layer.cornerRadius = 24
    buttonOut.setTitleColor(UIColor.black, for: .normal)
    buttonOut.layer.borderColor = UIColor.black.cgColor
    buttonOut.layer.borderWidth = 1
    buttonOut.backgroundColor = UIColor.white

    resultLabel.text = result?.getResult.message
    userLabel.text = result?.userHandSign.text
    computerLabel.text = result?.computerHandSign.text
  }

}
