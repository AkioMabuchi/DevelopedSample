//
//  ViewController.swift
//  Marubatsu
//
//  Created by 馬渕明雄 on 2018/05/28.
//  Copyright © 2018年 Akio Mabuchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!

    var playerWin:Int = 0
    var playerLose:Int = 0
    var playerDraw:Int = 0
    
    var marubatsuBoard:ArraySlice<Int> = [0,0,0,0,0,0,0,0,0,0]
    
    let boardPositionX:[Double] = [0.0, 0.0, 125.0, 250.0, 0.0, 125.0, 250.0, 0.0, 125.0, 250.0]
    let boardPositionY:[Double] = [0.0, 88.0, 88.0, 88.0, 213.0, 213.0, 213.0, 338.0, 338.0, 338.0]
    
    var boardControl:Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startButton.backgroundColor = UIColor.clear
        startButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        startButton.layer.borderColor = UIColor.blue.cgColor
        startButton.layer.borderWidth = 2.0
        startButton.layer.cornerRadius = 7.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickStartButton(_ sender: UIButton) {
        startButton.isEnabled = false
        startButton.layer.borderColor = UIColor.lightGray.cgColor
        startButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        startButton.setTitle("RETRY", for: .normal)
        firstLabel.text = "先手："
        marubatsuBoard[1...9] = [0,0,0,0,0,0,0,0,0]
        Opponent.initialize()
        if (playerWin + playerLose + playerDraw) % 2 == 0{
            changeTurnToPlayer()
        } else {
            changeTurnToOpponent()
        }
        drawBoard()
    }
    
    func changeTurnToPlayer() {
        for i in 1...9 {
            if marubatsuBoard[i] == 0{
                let pieceButton = UIButton()
                pieceButton.addTarget(self, action: #selector(ViewController.putPiece(_:)), for: UIControlEvents.touchUpInside)
                pieceButton.frame = CGRect(x: boardPositionX[i], y: boardPositionY[i], width: 125.0, height: 125.0)
                pieceButton.tag = 20 + i
                view.addSubview(pieceButton)
            }
        }
        messageLabel.text = "あなたの番です。"
    }
    
    @objc func putPiece(_ sender:UIButton){
        let number:Int = sender.tag - 20
        for v in view.subviews{
            if let v = v as? UIButton, v.tag >= 21, v.tag <= 29{
                v.removeFromSuperview()
            }
        }
        marubatsuBoard[number] = 1
        switch judgeVictory(1){
        case 0:
            changeTurnToOpponent()
        case 1:
            finishGame(0)
        case 2:
            finishGame(2)
        default:
            break
        }
        drawBoard()
    }
    
    func changeTurnToOpponent() {
        messageLabel.text = "コンピュータの番です。"
        Opponent.setBoard(marubatsuBoard)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.opponentTurn), userInfo: nil, repeats: false)
    }
    
    @objc func opponentTurn(){
        marubatsuBoard[Opponent.getChoice()] = 2
        switch judgeVictory(2){
        case 0:
            changeTurnToPlayer()
        case 1:
            finishGame(1)
        case 2:
            finishGame(2)
        default:
            break
        }
        drawBoard()
    }
    
    func finishGame(_ s:Int){
        switch s{
        case 0:
            playerWin += 1
            messageLabel.text = "あなたの勝利です。"
        case 1:
            playerLose += 1
            messageLabel.text = "コンピュータの勝利です。"
        case 2:
            playerDraw += 1
            messageLabel.text = "引き分けです。"
        default:
            break
        }
        startButton.isEnabled = true
        startButton.layer.borderColor = UIColor.blue.cgColor
        startButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        resultLabel.text = "ただいまの成績：\(playerWin)勝、\(playerLose)敗、\(playerDraw)分"
        if (playerWin + playerLose + playerDraw) % 2 == 1{
            firstLabel.text = "先手：コンピュータ"
        }else{
            firstLabel.text = "先手：あなた"
        }
    }

    func drawBoard(){
        for v in view.subviews{
            if let v = v as? UIImageView, v.tag == 10{
                v.removeFromSuperview()
            }
        }
        for i in 1...9{
            let rect = CGRect(x: boardPositionX[i], y: boardPositionY[i], width: 125.0, height: 125.0)
            let imageViewMarubatsu = UIImageView(frame: rect)
            imageViewMarubatsu.contentMode = .scaleAspectFit
            imageViewMarubatsu.tag = 10
            if marubatsuBoard[i] == 1{
                imageViewMarubatsu.image = UIImage(named: "Marubatsu-O2.pdf")
                self.view.addSubview(imageViewMarubatsu)
            }else if marubatsuBoard[i] == 2{
                imageViewMarubatsu.image = UIImage(named: "Marubatsu-X2.pdf")
                self.view.addSubview(imageViewMarubatsu)
            }
        }
    }
    
    func judgeVictory(_ s:Int) -> Int{
        let marked1:[Int] = [1,1,1,2,3,3,4,7]
        let marked2:[Int] = [2,4,5,5,5,6,5,8]
        let marked3:[Int] = [3,7,9,8,7,9,6,9]
        for i in 0...7{
            if marubatsuBoard[marked1[i]] == s, marubatsuBoard[marked2[i]] == s, marubatsuBoard[marked3[i]] == s{
                return 1
            }
        }
        for i in 1...9{
            if marubatsuBoard[i] == 0{
                return 0
            }
        }
        return 2
    }
}
