//
//  RockPaperScissorsIdentifier.swift
//  rock-paper-scissors
//
//  Created by Hélio Mesquita on 12/05/19.
//  Copyright © 2019 Hélio Mesquita. All rights reserved.
//

import Foundation

enum RockPaperScissorsIdentifier: String, CaseIterable {
  case paper, rock, scissors

  var text: String {
    switch self {
    case .rock:
      return "👊🏽"
    case .scissors:
      return "✌🏽"
    case .paper:
      return "🖐🏽"
    }
  }

}

class RockPaperScissorsResult {

  let userHandSign: RockPaperScissorsIdentifier
  let computerHandSign: RockPaperScissorsIdentifier

  init(userHandSign: RockPaperScissorsIdentifier, computerHandSign: RockPaperScissorsIdentifier) {
    self.userHandSign = userHandSign
    self.computerHandSign = computerHandSign
  }

  enum Results {
    case winner, loser, draw, invalid

    var message: String {
      switch self {
      case .winner:
        return "Congratulation you win"
      case .loser:
        return "You lost, try again"
      case .draw:
        return "Draw, try again"
      case .invalid:
        return "Impossible to identify you hand, try again"
      }
    }
  }

  var getResult: Results {
    
    if computerHandSign == userHandSign {
      return .draw
    }

    if computerHandSign == .rock && userHandSign == .paper {
      return .winner
    }

    if computerHandSign == .rock && userHandSign == .scissors {
      return .loser
    }

    if computerHandSign == .paper && userHandSign == .rock {
      return .loser
    }

    if computerHandSign == .paper && userHandSign == .scissors {
      return .winner
    }

    if computerHandSign == .scissors && userHandSign == .paper {
      return .loser
    }

    if computerHandSign == .scissors && userHandSign == .rock {
      return .winner
    }

    return .invalid
  }


}
