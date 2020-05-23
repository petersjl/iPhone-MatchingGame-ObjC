//
//  ViewController.swift
//  MatchingGame
//
//  Created by CSSE Department on 4/14/20.
//  Copyright © 2020 CSSE Department. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var gameBoardButtons: [UIButton]!
    
    var game = MatchingGame()

    @IBAction func pressedNewGame(_ sender: Any) {
        game = MatchingGame()
        updateView()
        print(game)
    }
    
    @IBAction func pressedGameButton(_ sender: Any) {
        let button = sender as! UIButton
        if !game.pressedCard(at: button.tag){
            return
        }
        updateView()
        if game.gameState == .GameStateTurnComplete{
            delay(1.2){
                let check = self.game.startNewTurn()
                self.updateView()
                if check{
                    self.delay(1.2){
                        self.pressedNewGame("")
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if UIDevice.current.userInterfaceIdiom == .pad {
            let fontName = gameBoardButtons[0].titleLabel?.font.fontName
            for button in gameBoardButtons{
                button.titleLabel?.font = UIFont(name: fontName!, size: 100)
            }
        }
        updateView()
        print(game)
    }
    
    func updateView(){
        for index in 0...19{
            switch game.getCardState(at: index){
            case .CardStateHidden:
                gameBoardButtons[index].setTitle("\(game.cardBack)", for: .normal)
            case .CardStateRemoved:
                gameBoardButtons[index].setTitle("", for: .normal)
            case .CardStateShowing:
                gameBoardButtons[index].setTitle("\(game.cards[index])", for: .normal)
            default:
                print("You made new bad data... good job")
            }
        }
    }
    
    // Helper method to create a time delay. Copied from:
    // http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
    // See answer with most votes for usage examples (VERY easy) delay(1.2) { ... }
    // Copy this snippet to your ViewController file (not realy useful in the model).
    // This is *one* way to solve the 1.2 second delay requirement.
    func delay(_ delay:Double, closure:@escaping ()->()) {
      let when = DispatchTime.now() + delay
      DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }


}

